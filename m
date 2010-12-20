Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0LTNzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:55:40 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:51368 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab0LTNzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:55:39 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 08:55:39 EST
Date: Mon, 20 Dec 2010 14:45:48 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3] Xen memory balloon driver with memory hotplug support
Message-ID: <20101220134548.GA6749@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch is new implementation of Xen memory balloon driver
with memory hotplug support. Additionally, it contains some
balloon driver extra features and fixes. It cleanly applies
to Linux kernel Ver. 2.6.36.

Daniel
