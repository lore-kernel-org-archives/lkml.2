Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab0ERSP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:15:56 -0400
Received: from ferdi.naasa.net ([87.106.227.76]:49901 "EHLO ferdi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab0ERSPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:15:54 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 14:15:53 EDT
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: =?utf-8?q?C=C3=A9dric_Godin?= <cedric@belbone.be>
Subject: Re: drm regression on resume with -rc7 (bisected to 797fd5b9dad12a100c81b5782573a41259728cb1)
Date: Tue, 18 May 2010 20:06:45 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.4; KDE/4.4.3; i686; ; )
Cc: Marek =?utf-8?q?Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
       dri-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>
References: <4BEB0EE6.1060002@belbone.be>
In-Reply-To: <4BEB0EE6.1060002@belbone.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201005182006.45798.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday, 12. May 2010 schrieb Cédric Godin:
Hi,

> When resuming my laptop from a -rc7, my X session reacted 
weirdly.
> Reading the dmesg log, I had :
> 
> May 12 21:58:03 enea kernel: [  122.627332] 
[drm:radeon_ib_schedule]
> *ERROR* radeon: couldn't schedule IB(0).
> May 12 21:58:03 enea kernel: [  122.627342] 
[drm:radeon_cs_ioctl]

same problem here with 2.6.34 and Thinkpad T40 (Radeon Mobility 
7500). The problem appeared after my upgrade to 2.6.34. 
2.6.33.X does not have this problem. Is there any patch 
available that I can test?

regards,
Jörg
