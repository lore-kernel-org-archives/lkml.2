Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab1LFBMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:12:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62568 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1LFBMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:12:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6551"; a="143984658"
Message-ID: <7fac345a60d692e55a6390bd3557b29d.squirrel@www.codeaurora.org>
Date: Mon, 5 Dec 2011 17:12:29 -0800 (PST)
Subject: Extending OPP Functionality
From: khugans@codeaurora.org
To: nm@ti.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        skannan@codeaurora.org, mattw@codeaurora.org, jchokshi@codeaurora.org,
        sboyd@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth Menon,

We have a number of drivers that manage power/performance levels in their
own ways and we are looking for a way to consolidate these similar
implementations in one place.  We want to scale multiple voltage levels,
clocks and bandwidth requests along with each other. For example our L2
depends on two power rail voltages.

We’ve observed that OPP tackles this for single voltage-frequency pair,
but doesn’t manage additional data that may be associated with
performance/power levels.  Would it make sense to extend OPP to handle
implementation-specific data pointers to handle this generically?

Thanks,
Khugan


