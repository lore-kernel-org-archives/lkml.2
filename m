Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab1EaJCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:02:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25393 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1EaJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:02:37 -0400
Date: Tue, 31 May 2011 11:00:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rene Herman <rene.herman@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 0/3] thermal: Cleanups
Message-ID: <20110531110016.7b232c85@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

I'm resending the patch set refreshed to apply on top of 3.0-rc1. No
functional changes since v2.

[PATCH 1/3] thermal: Hide CONFIG_THERMAL_HWMON
[PATCH 2/3] thermal: Split hwmon lookup to a separate function
[PATCH 3/3] thermal: Make THERMAL_HWMON implementation fully internal

-- 
Jean Delvare
