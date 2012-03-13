Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab2CMAuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:50:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881Ab2CMAuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:50:19 -0400
Message-ID: <4F5E99C4.7060305@zytor.com>
Date: Mon, 12 Mar 2012 17:50:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net> <4F5E76CE.4030601@zytor.com> <20120312223144.GA9636@host2.jankratochvil.net> <4F5E91DE.80609@zytor.com> <20120313002725.GA17828@host2.jankratochvil.net> <4F5E956F.3070108@zytor.com> <20120313003639.GA18427@host2.jankratochvil.net> <4F5E97EA.6030001@zytor.com> <20120313004642.GA19090@host2.jankratochvil.net>
In-Reply-To: <20120313004642.GA19090@host2.jankratochvil.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 05:46 PM, Jan Kratochvil wrote:
> On Tue, 13 Mar 2012 01:42:18 +0100, H. Peter Anvin wrote:
>> There is no 100% reliable solution possible -- you have no guarantee of
>> any kind that the library executable still exists.
> 
> I have guarantee that the library binary mapped in memory identified by
> build-id can be found out there in the could.  There is no other guarantee.
> And this guarantee fails with other solutions.
> 
> If you say that it is _additional_ info to build-id then yes, one can always
> use build-id if everything else fails.  But then the non-build-id information
> is redundant and it can just lead to wrong toolchain solutions - which has
> already happened (Apport).

You're thinking of a particular use case which isn't necessarily the
only one that matters.  It might be the only one that matters to *you*,
but that's very different to what matters to a developer, for example.

And yes of course the build-id should be included.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

