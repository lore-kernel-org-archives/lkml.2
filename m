Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab1CDVyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:54:04 -0500
Received: from smtp.getmail.no ([84.208.15.66]:65399 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab1CDVyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:54:02 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 16:54:02 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Date: Fri, 04 Mar 2011 21:53:57 +0100
Subject: Re: Renicing for OpenGL smoothness.
To: linux-kernel@vger.kernel.org
From: Notifications <notifications@paradoxuncreated.com>
Message-id: <op.vrt6z7bu4557yb@localhost.localdomain>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I was thinking, maybe some of you could inform me, which processes  
> are involved in getting the graphics on-screen.
> I have already started making a renicing script.

Well, there's just two processes that I couldn't find information on  
online though, kintegrityd and kworker. I set them to highpri for the  
moment, in my script. However the script didn't seem to make much of a  
difference, so the processes that run on Ubuntu Natty Narwhal seems to be  
quite well behaved. It's just a principle though, that any background  
processes shouldn't be able to request a lot of cpu, while I am running my  
opengl app. I do see that the ubuntu folks have reniced some processes of  
their own though.
[khelper] [kintegrityd] [kblockd] [kacpid] [kacpi_notify] [kacpi_hotplug]  
[ata_sff] and more are all at -20. Seems to be quite the opposite of what  
I am doing...

