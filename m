Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0L2RBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 12:01:47 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:47272 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0L2RBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 12:01:36 -0500
Date: Wed, 29 Dec 2010 18:00:59 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R2 0/7] Xen memory balloon driver with memory hotplug support
Message-ID: <20101229170059.GE2743@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch (r2) is new implementation of Xen memory balloon driver
with memory hotplug support. Additionally, it contains some
balloon driver extra features and fixes. It cleanly applies
to Linux kernel Ver. 2.6.36.

Daniel
