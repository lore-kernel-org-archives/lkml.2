Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0DRTq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:46:59 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:46190 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0DRTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:46:58 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: Module.symvers file
Date: Sun, 18 Apr 2010 15:46:56 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4; KDE/4.3.5; x86_64; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201004181546.56064.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I just found that a make all in 2.6.34-rc4 will generate the Module.symvers 
file.  But my normal build and install does not.

What do I need to add to my regular 'makeit' file in order to have this file 
built by a normal build?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Over the shoulder supervision is more a need of the manager than the
programming task.
