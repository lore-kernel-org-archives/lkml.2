Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1ENSr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:47:29 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:60565 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501Ab1ENSr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:47:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=tDR7Dfs6TNLejQTPXKnRgAPfFeiWlhqyztRmmzPVZTjU5Kkyp2odzYjwmdRbGGp4;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4DCECE3F.1080307@earthlink.net>
Date: Sat, 14 May 2011 14:47:27 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 945gma display blank after power failure regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec798d3825b4074fa097ece95f9c3917c784350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have kernel 2.6.37  and an
Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated 
Graphics Controller (rev 03)
in an asus s96f laptop. The battery is shot so it doesn't stay up for a 
second on a power failure. I have
recently started experiencing a problem where if the display has been 
blanked by KDE because of
being idle and I have a power failure then when the laptop boots up I 
have a completely blank display.
I wait till I think it is up and do a blind login as my KDE session 
starts up it turns on the display.

When is it booting I don't see anything - not the bios screen nothing. 
This is very disconcerting.
The first time it happened I thought my lcd panel had died.

Any ideas on how to keep this from happening. I don't think this 
happened on previous kernels.

Thank,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



