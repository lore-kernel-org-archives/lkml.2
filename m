Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0I2H4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:56:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52466 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0I2H4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O1oXB5bwbtWltRtHel4Mkmiox/b9F1hj7kyFlJOxljYwaRxk9I7O/s8qKuEn1yoBIb
         ORZKjgyeHiY6Th29h2yXfm+U24RuEeDP7PQncBhYuk8bSAGEIc+e17vyH+2HgZDFBm/l
         14TymisifErQBYEvb0Q9s/iDJznfhtxlWb4LY=
MIME-Version: 1.0
In-Reply-To: <20100928142955.GB13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-3-git-send-email-ying.huang@intel.com>
	<20100927080106.GA32222@erda.amd.com>
	<1285576760.20791.70.camel@yhuang-dev>
	<20100927090056.GJ13563@erda.amd.com>
	<20100927153315.GB26290@redhat.com>
	<20100927164502.GS13563@erda.amd.com>
	<1285637617.20791.146.camel@yhuang-dev>
	<20100928142955.GB13563@erda.amd.com>
Date: Wed, 29 Sep 2010 15:56:42 +0800
Message-ID: <AANLkTikOUV+-WX7eek7ocwQLDxTcWSYJ4kga6ctTi9MG@mail.gmail.com>
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI SERR error
From: huang ying <huang.ying.caritas@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 10:29 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 27.09.10 21:33:37, Huang Ying wrote:
>
>> I suggest to
>> print the reason byte only if (!(reason & 0xc0) && reason), where the
>> reason is really unknown.
>
> Why make it this complex for an error message?

It's just a "else" branch for original "if (reason & 0xc0)" code, so
it is not too complex.

Best Regards,
Huang Ying
