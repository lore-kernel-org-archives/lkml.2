Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0DGUw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:52:58 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:37524 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0DGUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=JetS+b9UGngGKHKZc6NuQLmCxTai5WGSIsYIqesL4fnIe1ofAxAJP+UXNnXYUfE8+Q
         4uagh9WR1holEetshMNFAG4QqK1wpYGceUDP3m1doZF+kTPp3Hndfivvd1VoP4gAwerw
         76zR5xyI8DamE7lwe9B7QkNWvQIu766mOf7TA=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org, maciej.rutecki@gmail.com
Subject: Re: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Date: Wed, 7 Apr 2010 22:52:08 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-2-amd64; KDE/4.3.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       thommycheck@gmail.com, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       eric.y.miao@gmail.com, zaurus-devel@www.linuxtogo.org
References: <20100313122754.GD2192@elf.ucw.cz> <20100401060624.GA1329@ucw.cz> <201004072226.34272.maciej.rutecki@gmail.com>
In-Reply-To: <201004072226.34272.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004072252.08354.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 7. dubna 2010 22:26:34 Maciej Rutecki napsal(a):
> On czwartek, 1 kwietnia 2010 o 08:06:25 Pavel Machek wrote:
> > Hi!
> >
> > > > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
> > > > seem to even reset the framebuffer (I'm using kexec -- so it stays
> > > > stuck on on previous screen).
> >
> > Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
> > time to set up serial console, yet :-(. Any ideas?
> > 								Pavel
> 
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=15712
> for your bug report, please add your address to the CC list in there,
>  thanks!
> 
Pavel, you broke it ... and here you say something about sane arm maintainers 
;-)
