Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab0FFF6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 01:58:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54468 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0FFF6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 01:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ekQHIfdvbhAZjREITZE36iWXT8E/4VBdjPhoDECQmEfPm+eREQr3cZ1x32Ko/uT1DO
         OUcf0CF2B2uXpBXHwkxHFhZhYIQoZmXcgaVsH9rOaYO6vsBR8LSemg9DZQc9Nze/zZ2F
         4biGsfi/cZXdrvkp8j9PHYloN1sFltNheGnK0=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Subject: Re: Linux 2.6.34 causes system lockup on Compaq Presario 2200 Laptop
Date: Sun, 6 Jun 2010 07:58:42 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTil6GGSoc8TpzRacr1LZBZS3ee3H1ejYDSqfdul4@mail.gmail.com>
In-Reply-To: <AANLkTil6GGSoc8TpzRacr1LZBZS3ee3H1ejYDSqfdul4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006060758.42766.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 27 maja 2010 o 20:08:48 Jeffrey Merkey wrote:
> 2.6.34 causes a hard system lockup when the screen blanking activates
> for more than 10 minutes with low battery power.  Also misreports
> battery level as "battery broken at 14%" when the battery is fully
> charged.  Does not occur with 2.6.28 but 2.6.33 also seems to do it as
> well.  software debugging tools useless as the keyboard does not
> respond.
> 
> Jeff

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16136
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
