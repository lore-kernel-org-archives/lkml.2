Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0CVLBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:01:19 -0400
Received: from snt0-omc1-s3.snt0.hotmail.com ([65.55.90.14]:24578 "EHLO
	snt0-omc1-s3.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab0CVLBR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:01:17 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 07:01:17 EDT
Message-ID: <SNT110-W58162EDFB417DBBD0AE6C8C4270@phx.gbl>
X-Originating-IP: [81.208.53.251]
From: Vassilios Zafiropoulos <vasili3000@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: broken microphone
Date: Mon, 22 Mar 2010 10:55:06 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Mar 2010 10:55:05.0985 (UTC) FILETIME=[21AB5710:01CAC9AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hello,



 this commit seems to break my microphone. please cc me, as i

 am not written on the mailing list. For any other info, please
ask.



 yours,

 vasilis.



 --



 vasili@vaccone 

 /usr/src/linux-2.6 $ sudo git bisect bad



 f5271101faf1655d862849f42518c2a88ef394fb is the first bad commit

 commit 

 f5271101faf1655d862849f42518c2a88ef394fb

 Author: Lydia Wang 

 <lydiawang@viatech.com.cn>

 Date:   Sat Oct 10 19:07:35 2009 +0800



     

 ALSA HDA VIA: Add VIA_CTL_WIDGET_ANALOG_MUTE control type

     

     

 Enter low power state if AA-Path volume is muted.

     

     Signed-off-

 by: Lydia Wang <lydiawang@viatech.com.cn>

     Signed-off-by: Logan Li 

 <loganli@viatech.com.cn>

     Signed-off-by: Takashi Iwai <tiwai@suse.

 de>



 :040000 040000 ab1ae14ff67f0b08848faeb3ad68def7f3e727f0 

 0bfbfde11fe32e87e8edbdb3c4d03c2d30370393
M      sound 		 	   		  
_________________________________________________________________
Hotmail: Free, trusted and rich email service.
https://signup.live.com/signup.aspx?id=60969