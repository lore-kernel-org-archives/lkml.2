Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2AWOcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:32:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52747 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317Ab2AWOcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:32:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120123141710.GA26809@sepie.suse.cz>
References: <1326819051-25712-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1326861219.490.4.camel@cr0> <CAPXgP12vChg=820uamRa6dTekEQD_xa6mg-nroOm1br+7-JCqw@mail.gmail.com>
 <20120123141710.GA26809@sepie.suse.cz>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 23 Jan 2012 12:32:22 -0200
Message-ID: <CAMOw1v7+Hb8RgBdA3ZPzEFM0Mt5y=_6=RF12CodciOw0Yq2vmg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: do not check for ancient modutils tools
To: Michal Marek <mmarek@suse.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Cong Wang <amwang@redhat.com>,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:17 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Fri, Jan 20, 2012 at 05:40:58PM +0100, Kay Sievers wrote:
>> On Wed, Jan 18, 2012 at 05:33, Cong Wang <amwang@redhat.com> wrote:
>> > On Tue, 2012-01-17 at 14:50 -0200, Lucas De Marchi wrote:
>> >> scripts/depmod.sh checks for the output of '-V' expecting that it has
>> >> module-init-tools in it. It's a hack to prevent users from using
>> >> modutils instead of module-init-tools, that only works with 2.4.x
>> >> kernels. This however prints an annoying warning for kmod tool, that is
>> >> currently replacing module-init-tools.
>
> You could call kmod "module-init-tools 3.13 (compatible; kmod 3)" ;)
>
> Just kidding.

I even wrote a patch to fake kmod as module-init-tools 4.0. Not worth
applying though  :-)


>
>> >> Rather than putting another check for kmod's version, just remove it
>> >> since users of 2.4.x kernel are unlikely to upgrade to 3.x, and if they
>> >> do, let depmod fail in that case because they should know what they are
>> >> doing.
>> >>
>> >> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
>> >
>> > Acked-by: WANG Cong <amwang@redhat.com>
>>
>> Michal, mind picking this up? The warning it produces with kmod is
>> really misleading, and the check seems unnecessary these days.
>
> I applied it to kbuild.git#rc-fixes and will send it to Linus for 3.3.

Thanks
Lucas De Marchi
