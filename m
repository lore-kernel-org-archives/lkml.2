Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab2BCIq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:46:27 -0500
Received: from smtp10.mail.sp.isp-net.nl ([217.149.192.65]:38288 "EHLO
	smtp10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2BCIq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:46:26 -0500
X-Greylist: delayed 37266 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Feb 2012 03:46:25 EST
Message-ID: <4F2B0D4D.3000304@xmsnet.nl>
Date: Thu, 02 Feb 2012 23:25:17 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110903 Thunderbird/3.1.13
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dosemu graphics broken in v3.3-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running old graphic dos games in full screen dosemu, the screen 
turn blank when the game switches from text to graphics.

My laptop has an Intel Corporation Mobile 945GM/GMS, 943/940GML Express 
Integrated Graphics Controller

-- 
Hans
