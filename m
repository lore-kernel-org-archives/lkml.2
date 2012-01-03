Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2ACOfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:35:51 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:54318
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753726Ab2ACOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:35:48 -0500
Message-ID: <4F031233.7040007@compulab.co.il>
Date: Tue, 03 Jan 2012 16:35:31 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Kroah-Hartman <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Sanjeev Premi <premi@ti.com>,
        Kyle Manna <kyle@kylemanna.com>, stable@vger.kernel.org
Subject: Several MFD patches for stable
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Chris,

I've found several MFD patches that I think should have been
applied also to stable, but they hadn't been applied
(probably because nobody cared to send them to stable@vger.kernel.org).

The patches are upstream:
e178ccb33569da17dc897a08a3865441b813bdfb (mfd: Fix mismatch in twl4030 mutex lock-unlock)
66cc5b8e50af87b0bbd0f179d76d2826f4549c13 (mfd: Copy the device pointer to the twl4030-madc structure)
d0e84caeb4cd535923884735906e5730329505b4 (mfd: Check for twl4030-madc NULL pointer)
3d6271f92e98094584fd1e609a9969cd33e61122 (mfd: Turn on the twl4030-madc MADC clock)

I don't know what is right flow that I should follow
to get those into the stable tree.

Thanks for any assistance.

-- 
Regards,
Igor.
