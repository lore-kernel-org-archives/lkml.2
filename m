Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0KGXHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:07:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35273 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab0KGXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=UYov4oFMCraPTrrPs5FQ97h5AUNCIi+NHtbOaknvYZnQqKNsRIdM5+s5QpbuwidS43
         WBbSo734F6/aN8xzqeu9ytWJ3GfejGfkSrAQme/dEoplpSxSDmNbN97wDD88FKcpv2By
         vLX0sT8ys9ltJ8Vjs4KytJ9e771dmwhL1YOoQ=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: fstat suddenly return -EINVAL [Was: Bus error on make allyesconfig, kernelbuild with HEAD]
In-Reply-To: <20101107223056.GA23871@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org> <87tyjtjd7m.fsf@gmail.com> <20101107170700.GA22684@merkur.ravnborg.org> <87mxplypid.fsf@gmail.com> <20101107223056.GA23871@merkur.ravnborg.org>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 07 Nov 2010 18:07:08 -0500
Message-ID: <87lj54raw3.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010 23:30:56 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> I looked briefly at the fstat implmnetation in the kernel and
> this did not give me any hints.
> I therefore changed to subject to attrack attention of more readers.
> 
Thanks!

> Can you supply us with a bit more information about your system:
> - filesystem (as fstat seems to reach filesystem specific code)
> - glibc version 
> - box (architecture + 32 or 64 bit kernel)
> - do you see other things misbehave or is this only a kernel build thing
> 
> If you have provided this info in the past I have missed it.
> 
The kernel tree resides on an ext4 partition. The machine has two Xeon
E5520 processors and runs 64-bit Ubuntu 10.04 which uses eglibc 2.11.1.
Note that the kernel is being cross-compiled for ARM under an
OpenEmbedded toolchain (have tried both gcc 4.4.4 and 4.5). This is the
only strange behavior that I know of.

Cheers,

- Ben
