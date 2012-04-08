Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2DHJ63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 05:58:29 -0400
Received: from forward8.mail.yandex.net ([77.88.61.38]:48782 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2DHJ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 05:58:28 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2012 05:58:28 EDT
Message-ID: <4F815FCE.5040002@yandex.ru>
Date: Sun, 08 Apr 2012 13:52:14 +0400
From: Alex Stone <alex.parchment@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120406 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Timing 250 versus 1000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No doubt i'm likely to get hammered for asking this on a technical ML, 
but i'm brave enough and interested enough to risk it.

Is there an important reason why timing in the kernel is set to 250 by 
default?

I'm using linux to write music with. With the addition of many of the RT 
patches in the standard kernel, recording audio at low latencies with a 
standard kernel is no longer a problem, but for those of us who write a 
lot of midi driven work, we're still more or less required to use some 
sort of RT kernel to get any degree of playback timing accuracy.

I appreciate my use case is just one among many, but i've done a lot of 
research on the interlink, and unless i'm missing something really 
simple here, i can't find a reason why the default timer can't be set at 
1000, and be done with it.

I appreciate you chaps are busy, and elbow deep in code, just a "yes it 
could" or "no we won't" would suffice.

Thanks,

Alex.

