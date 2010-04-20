Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0DTTFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:05:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37217 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0DTTFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=xgi3cQsp8e0mAFuD45CNlfF6BQ+XuX/B5FEG7Adz3tTugKDpKKuiUmO3kjKw47FMrp
         qsrMzaLx4AS0IUSHhr8iRcS7EIskhlLTrTuBismCshI6dUhg3yJ5LGG2iMsB1k/arEx4
         i3yLN9ViEoAcjqfCK+al0LSnj+kAkhy2EnZXQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: jplatte@naasa.net, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kernel BUG at kernel/power/snapshot.c:522
Date: Tue, 20 Apr 2010 21:03:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004171601.05025.jplatte@naasa.net>
In-Reply-To: <201004171601.05025.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004202103.43869.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 17 kwietnia 2010 o 16:01:04 Joerg Platte wrote:
> Hi,
> 
> I get the bug listed in the subject frequently, but not always,
> when I invoke s2disk to suspend to disk with a self-compiled
> kernel 2.6.33.X on my Thinkpad T40. Unfortunately, I cannot
> provide the full error log as text since the error is only
> displayed on the screen. You can get a photo of the full error
> log here:
> https://ferdi.naasa.net/url/jplatte/IMG_1931.jpg
> 
> If I remember correctly the problem appeared with kernel 2.6.33-
> rcX. I first ignored it but now it is getting more and more
> annoying :)
> 
> regards,
> Jörg

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15816
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
