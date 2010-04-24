Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0DXNNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 09:13:51 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44330 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0DXNNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 09:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=LNQfv1HOFayekmJxMbC8ZrXPlvdxdywk1vGUFPNq3APMnf1Rkc7Xi9KUaADlNtbSRD
         gvfPJQ9VPNp3C57KJfo+6SMuNhyH3MrBokWrrdq0Uu9VpzJRBLBh70GTQd5Ber4T/bq4
         KcHMUh9bc65VyoY7veMK7kUWj4IRX9kk4I2vs=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Sat, 24 Apr 2010 14:13:44 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004230806.13628.pedrogfrancisco@gmail.com> <201004241027.01241.pedrogfrancisco@gmail.com> <20100424121347.GN29093@bicker>
In-Reply-To: <20100424121347.GN29093@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004241413.45131.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Sábado, 24 de Abril de 2010 13:13:47 Dan Carpenter escreveu:
> On Sat, Apr 24, 2010 at 10:27:00AM +0100, Pedro Francisco wrote:
> > A Sexta, 23 de Abril de 2010 20:13:42 Dan Carpenter escreveu:
> > > On Fri, Apr 23, 2010 at 08:06:13AM +0100, Pedro Francisco wrote:
-snip

> > However I've posted the dmesgs here [
> > http://ubuntuforums.org/showthread.php?t=1457568 ] prior to asking for
> > help in LKML. Kernel version is Ubuntu's 2.6.32, not Vanilla.
> > 
> > I believe nothing significant can be extracted from them. Am I correct?
> 
> Well they have the 'M' taint for "Machine Check Exception" so that
> probably means the hardware is failing.
> 
> regards,
> dan carpenter

Only on two of them. Since when I get a BUG: Unable to handle paging request 
the system seems to get stuck and on 100% CPU after a while the CPU overheats 
I assumed those Machine Check Exceptions were due to the overheating caused by 
the 100% CPU usage caused by the errors. If it is due to that, the CPU 
throttles to prevent further overheating so it shouldn't affect anything.

-- 
Pedro
