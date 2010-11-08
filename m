Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0KHKPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:15:25 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59830 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0KHKPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:15:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UzOvB2Chw7hZG18yLUGZ1eJ+Y4dXUHx/DDgM3DYc8ICjUXylxnA2ebSK1X/wUuoHPG
         +3Wz5F+VyZUHYZuwKza3VKjkA6+wH6PdEZDp15mLwdwxCoC5v7feEJL8z41G3ImRxcFI
         ChyNBLfTd5RCmnHXFYHWf+VDMY4ELbwjAjpss=
Date: Mon, 8 Nov 2010 18:20:02 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: fstat suddenly return -EINVAL [Was: Bus error on make
 allyesconfig, kernelbuild with HEAD]
Message-ID: <20101108101920.GA5527@cr0.nay.redhat.com>
References: <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de>
 <20100730084353.GB5638@cr0.nay.redhat.com>
 <87d3qicwxn.fsf@gmail.com>
 <87aalmcv0p.fsf@gmail.com>
 <20101106162426.GA14361@merkur.ravnborg.org>
 <87tyjtjd7m.fsf@gmail.com>
 <20101107170700.GA22684@merkur.ravnborg.org>
 <87mxplypid.fsf@gmail.com>
 <20101107223056.GA23871@merkur.ravnborg.org>
 <87lj54raw3.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lj54raw3.fsf@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 06:07:08PM -0500, Ben Gamari wrote:
>On Sun, 7 Nov 2010 23:30:56 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
>> I looked briefly at the fstat implmnetation in the kernel and
>> this did not give me any hints.
>> I therefore changed to subject to attrack attention of more readers.
>> 
>Thanks!
>
>> Can you supply us with a bit more information about your system:
>> - filesystem (as fstat seems to reach filesystem specific code)
>> - glibc version 
>> - box (architecture + 32 or 64 bit kernel)
>> - do you see other things misbehave or is this only a kernel build thing
>> 
>> If you have provided this info in the past I have missed it.
>> 
>The kernel tree resides on an ext4 partition. The machine has two Xeon
>E5520 processors and runs 64-bit Ubuntu 10.04 which uses eglibc 2.11.1.
>Note that the kernel is being cross-compiled for ARM under an
>OpenEmbedded toolchain (have tried both gcc 4.4.4 and 4.5). This is the
>only strange behavior that I know of.
>

But fixdep should be compiled by the host compiler...

So, does this error also occur when you do non-cross compiling on the
same partition?

Thanks for your testing!
