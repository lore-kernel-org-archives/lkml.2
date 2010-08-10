Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0HJJm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:42:59 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47310 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0HJJmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:42:54 -0400
Date: Tue, 10 Aug 2010 12:35:38 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 2/4] arch/frv: Removing dead HEARTBEAT config option
Message-ID: <20100810093537.GC22436@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <fafef93430b45ac966abc77ed061647af2814873.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fafef93430b45ac966abc77ed061647af2814873.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Aug 2010 09:35:33.0454 (UTC) FILETIME=[6143A6E0:01CB386F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 10, 2010 at 11:11:13AM +0200, ext Christian Dietrich wrote:
>diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
>index 0ddbbae..e86df6c 100644
>--- a/arch/frv/kernel/time.c
>+++ b/arch/frv/kernel/time.c
>@@ -66,12 +66,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
>
> 	do_timer(1);
>
>-#ifdef CONFIG_HEARTBEAT

should you instead change to CONFIG_LEDS_TRIGGER_HEARTBEAT ?

-- 
balbi

DefectiveByDesign.org
