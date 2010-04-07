Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0DGU0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:26:39 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:34712 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0DGU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=H5yxke1eortH84tTlU2YcxgbROn63H1tfw6+zttxLN2JsrEKv8Ezkb4/VzD2UDEAgO
         IEl7r3ZI8eYwc2v/uTJKJKOOAn15kfVUuVYDRmJdjSCQVpnZS+iC6x3+Fx7HDOSHO9Ul
         7s7GpXopHy2TQQQ84EIomAV73P/zuHU+bHrB4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Date: Wed, 7 Apr 2010 22:26:34 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3; KDE/4.3.4; i686; ; )
Cc: Cyril Hrubis <metan@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       thommycheck@gmail.com,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20100313122754.GD2192@elf.ucw.cz> <20100315102830.GA10288@atrey.karlin.mff.cuni.cz> <20100401060624.GA1329@ucw.cz>
In-Reply-To: <20100401060624.GA1329@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004072226.34272.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 1 kwietnia 2010 o 08:06:25 Pavel Machek wrote:
> Hi!
> 
> > > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
> > > seem to even reset the framebuffer (I'm using kexec -- so it stays
> > > stuck on on previous screen).
> 
> Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
> time to set up serial console, yet :-(. Any ideas?
> 								Pavel
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15712
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
