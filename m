Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1BXL2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:28:51 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:34704 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab1BXL2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:28:49 -0500
Date: Thu, 24 Feb 2011 12:27:42 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110224112742.GB29840@pcnci.linuxbox.cz>
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D663886.6080803@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4631468 records (last update: 20110224)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not very useful when the guest is making progress, I'm afraid.
can perf report help here?

> Can you try a little trace-cmd -e kvm -b 20000?
ugh, I'm afraid I'll have some dumb questions here :-[
You mean this: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git ?
and then re-execute qemu-kvm using it? or I'm totally wrong?

> Sure.  Something similar that came up - sometimes Windows IDE drivers  
> fall back to PIO mode.  Are you using IDE?  If so, please check whether  
> it's using DMA or PIO.
I'll check, but this problem occurs only during fsck phase, when to guest boots, then it runs pretty fast..
so maybe during boot it might fall back to PIO, but from guest, I guess I won't have a chance
to find out.. can I somehow check it from host?
>
> -- 
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
