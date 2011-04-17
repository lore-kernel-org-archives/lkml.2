Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1DQSkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:40:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39107 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1DQSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WHblzqTNcbw0zGnkHr/RfF5lM3QvgGDM5KE1eb/UaMrtLzy5jrxCQQomZs6qqJCt/1
         WqHloqL9SgGEjnsq1zj8JgM3M2SOrr9u0haqLHjKox5zSFcM00m+NW3uMszhWznd1YU2
         jxz3NgvlypxEf5MlgCrAZjd8IA/9DvxEyo6oQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Gottfried Haider <gottfried.haider@gmail.com>
Subject: Re: [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3 (works in 2.6.38.3)
Date: Sun, 17 Apr 2011 20:40:21 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
References: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
In-Reply-To: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172040.21852.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33482
for your bug report, please add your address to the CC list in there, thanks!

On sobota, 16 kwietnia 2011 o 18:38:59 Gottfried Haider wrote:
> Hello,
> 
> I am having problems pairing bluetooth devices in 2.6.39. Scanning
> works fine (hcitool scan), but when I try to pair a device using
> "bluez-simple-agent hci0 $MAC", I receive the following error message:
> "Creating device failed: org.bluez.Error.Failed: Input/output error"
> 
> The same command reliably works on a 2.6.38.3 kernel with pretty much
> the same config.
> 
> According to lsusb, I have a Broadcom Bluetooth Controller with ID
> 0a5c:217f. I don't see anything related in either of the dmesgs.
> My lspci output is here: http://sukzessiv.net/x120e/
> Userspace is an up-to-date Ubuntu 11.04 beta (with bluez 4.91).
> 
> If there are any debugging steps that I could do or patches to try or
> revert, let me know. Unfortunately I can't do a proper bisect since
> the machine is a netbook type.
> 
> cheers,
> gohai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
