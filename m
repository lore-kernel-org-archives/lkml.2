Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CTL67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 07:58:59 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36663 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1CTL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 07:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mYtNmIf+aXcCp1Sul9jHPH54hHaTzCEzI9mJc08MJbWkuzxGKuVT1dp1I60LXePMWS
         mEDXi8Fb0xlviCyFBD4vgkVA/fn0nY0HfIk/DwCzBJ4W3bcp4y3EgHmxEMa2fJxlp/bQ
         Yo8zfU/c8Kg5HoyFBwJW4w75Ww9nJF/v6Trd4=
Message-ID: <4D85EBFA.70908@tim-richardson.net>
Date: Sun, 20 Mar 2011 22:58:50 +1100
From: Tim Richardson <tim@tim-richardson.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101110 Lightning/1.0b2 Icedove/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel panic on resume from suspend to ram 2.6.38, with link to photo
 of screen
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My laptop is a Toshiba U400 with intel graphics. BIOS is latest. It's 
been running linux for three years, mostly Debian unstable.
Every 2.6.38 kernel I've tried gives a kernel panic on resume from ram 
suspend. I have tried three different 2.6.38 kernels from aptosid (all 
of them after release of 2.6.38) and the Debian unstable 2.6.38 which 
has just entered repositories.
This happens even in run-level 3 (xserver not running).
However, suspend to disk resumes happily.
I don't have any closed source drivers used: video is intel, wireless is 
intel, and virtualbox is OSE.
I have a photo of the console screen here:
https://picasaweb.google.com/te.richardson/Aptosid#5585718281112043778

PS I don't know is this is a kernel panic. The machine freezes hard, I 
must force a power-down. I can't find the messages in the photo in any 
system logs. The LED on the caps lock key flashes. This system has had 
no problems with any kernels in recent memory.






