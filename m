Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0CVTpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:45:11 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:55478 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab0CVTpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MZgpct4EH/ntkuObtVd6BpQenlm8p/9rQ52rQQzBNPh6jjFrgb7A97KSuAjjqOVgOs
         /27xAPE64g8eH8QqyliIjdvsTNua2uaO8tT4xHyAFXYporY9qS6PGFvpSkIyBtPv1aj7
         SzVM+DmLE/qcSE6tsyfzPjTF6ePkr0mLZx5Sw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rupjyoti Sarmah" <rsarmah@amcc.com>
Subject: Re: Failure with the 2.6.34-rc1 kernel
Date: Mon, 22 Mar 2010 20:45:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com>
In-Reply-To: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003222045.01278.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 16 marca 2010 o 16:45:38 Rupjyoti Sarmah wrote:
> Hi All,
> 
> We are seeing issues in booting some of our boards with this new kernel.
> Kernel version upto 2.6.33 works fine on the boards like Canyonlands,
> Katmai, Glacier etc.
> These boards are not booting with kernel later than 2.6.33. Please let
> me know how about fixing these issues ?

I created a Bugzilla entry athttps://bugzilla.kernel.org/show_bug.cgi?id=15611
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
