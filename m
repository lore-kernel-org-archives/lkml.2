Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0IRT0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:26:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34879 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab0IRT0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WMjvEPnU943yYlyOrsjz5QBv/kAHxj3RRw12KRk3d+66Dmf89HtZqcqRL89zdwX5s+
         KdXdUc9ZPsL3lABsAX6gm2+KUQ2BdNI9fVgL/xugCDP0Fas8RQdB0dhLh+Va3+P5N1Om
         JTbVRnaCsASOHLelU7+VGj3BoVR8c8mprsQV4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: infernix <infernix@infernix.net>
Subject: Re: PROBLEM: Kernel panic on 2.6.36-rc4 when loading intel_ips on Core i3 laptop
Date: Sat, 18 Sep 2010 21:26:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4C90D998.6050103@infernix.net>
In-Reply-To: <4C90D998.6050103@infernix.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009182126.01041.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 15 września 2010 o 16:35:04 infernix wrote:
> Hi,
> 
> I'm getting a kernel panic when I try to load the new Intel IPS
> powersaving code (intel_ips). It happens about 5 seconds after it gets
> loaded.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=18742
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
