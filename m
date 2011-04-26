Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1DZO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:56:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:9711 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab1DZO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:56:12 -0400
Date: Tue, 26 Apr 2011 16:56:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rene Herman <rene.herman@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 0/3] thermal: Cleanups
Message-ID: <20110426165600.1d9ac91b@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/3] thermal: Hide CONFIG_THERMAL_HWMON
[PATCH 2/3] thermal: Split hwmon lookup to a separate function
[PATCH 3/3] thermal: Make THERMAL_HWMON implementation fully internal

-- 
Jean Delvare
