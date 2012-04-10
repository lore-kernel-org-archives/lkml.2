Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2DJSXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:23:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47552 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755448Ab2DJSXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:23:18 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+CqZ0l+tKCgehGpWmwhwLci55O80dUh+NxmucYiO
	XnFjN9oq8MwwUV
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: /proc/interrupts has non-printable chars in kernel 3.3.1
Date: Tue, 10 Apr 2012 20:23:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.1; KDE/4.8.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201204101934.34046.toralf.foerster@gmx.de> <4F8479CD.5030907@suse.cz>
In-Reply-To: <4F8479CD.5030907@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204102023.07775.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jiri Slaby wrote at 20:19:57
> On 04/10/2012 07:34 PM, Toralf Förster wrote:
> > The interrrupt 47 shows (with powertop) a curious "Description" :
> > 
> > [@^EM-W] <interrupt>
> > 
> > under a stable Gentoo Linux at a Thinkpad T400  - the BIOS is the latest
> > available. FWIW I attached the output of the command  $>cat
> > /proc/interrupts
> 
> ...
> 
> >  47:     289270     468524   PCI-MSI-edge      @��
> 
> It would be great if you could dig out of dmesg, who is bound to the
> interrupt.
> 
> regards,
n22 /etc # dmesg | grep 'irq 47'
snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
