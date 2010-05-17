Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0EQJvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:51:12 -0400
Received: from toro.web-alm.net ([62.245.132.31]:52824 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0EQJvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:51:10 -0400
Message-Id: <20100517094136.094800562@osadl.org>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:41:36 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
       Carsten Emde <C.Emde@osadl.org>, LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20100510035031.GD9181@owl> <20100514065808.GA11598@owl>
Subject: [PATCH 0/2] hwmon: Update coretemp to current Intel processors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Here comes the current version of the coretemp patches. Huaxu did the initial
work; Jean suggested to submit them directly to Andrew.

I made some style changes as advised by checkpatch.

The patches have been tested successfully on Core 2 Duo and Quad, and on
Nehalem and Nehalem/Westmere where temperature readings were plausible and
changed with load as expected. When tested on an Atom processor (N270), the
temperature values were identical to previous versions of the coretemp
module and also changed with load. However, the readings should be higher
by 10 to 15C as compared to the outside temperature of the processor. Huaxu,
could you check? I would guess TjMax to be 105 instead of 90C in these
processors.

        Carsten.

