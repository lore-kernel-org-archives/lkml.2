Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0GNKue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:50:34 -0400
Received: from mail1.nippynetworks.com ([212.227.250.41]:59469 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0GNKud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:50:33 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 06:50:33 EDT
Message-ID: <4C3D94E3.9080103@wildgooses.com>
Date: Wed, 14 Jul 2010 11:43:47 +0100
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Raise initial congestion window size / speedup slow start?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, my network connection looks like 500Kbits with a round trip latency 
of perhaps 1s+ (it's a satellite link).

 From what I can see the linux initial congestion window is signficantly 
limiting me here, with slow start taking many many seconds to open up 
the window wide enough to get the data flowing?  For protocols like http 
this is really hurting with all the short lived connections never really 
getting up to speed.  (throw in some random packet loss and things 
really screech to a halt)

Reading around there appear to be several previous attempts to modify 
the kernel to start with a slightly wider initial congestion window, say 
10 packets.  (Seems even google did some work on this and agreed that a 
small of initial cwd to 10 ish, would help even many non satellite 
users?) However, all the work I can find is quite old and doesn't seem 
to give me much of a leg up in terms of experimenting with such changes 
on a modern kernel?

Does someone have some pointers on where to look to modify initial 
congestion window please?


Thanks

Ed W
