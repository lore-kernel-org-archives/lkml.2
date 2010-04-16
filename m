Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0DPPyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:54:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab0DPPyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=M1uiZ7/mFOr3yEiB/y6AwV/zI/RQvuVZab31A9RKn0zzXL4Pg59uvQ0LIkjvzw1Gic
         m6oqPmqqjgye8GqbRM/DUZ4TK5yf38M+JQri8M2JkAe4ZDDSTvLoYMoiJ0LYLNOXvxYg
         tXMA3jeVZueLYuSFw2LOkD06ourmPwXS4im08=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "=?utf-8?q?Fr=C3=A9d=C3=A9ric_L=2E_W=2E?= Meunier" 
	<fredlwm@gmail.com>
Subject: Re: it87 with 2.6.33.2: noise
Date: Fri, 16 Apr 2010 17:53:58 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3; KDE/4.3.4; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LNX.2.01.1004141835450.13955@dyndns.pervalidus.net>
In-Reply-To: <alpine.LNX.2.01.1004141835450.13955@dyndns.pervalidus.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004161753.58756.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 14 kwietnia 2010 o 23:39:20 Frédéric L. W. Meunier wrote:
> With 2.6.33.2, as soon as it87 is loaded, my speaker (or
> something I couldn't identify) starts like an alarm/ring and
> doesn't stop until I reboot.
> 
> It didn't happen with 2.6.32.
> 
> Apr 14 18:27:37 pervalidus kernel: it87: Found IT8716F chip at 0x228,
>  revision 3 --

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15797
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
