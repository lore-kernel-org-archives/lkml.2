Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2HCTgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:36:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43281 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2HCTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:36:34 -0400
Date: Fri, 3 Aug 2012 12:32:23 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/4 V2] Use get_online_cpus to avoid races involving CPU
 hotplug
Message-ID: <20120803193223.GA4227@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second version of the patches to fix races described in:

  https://groups.google.com/forum/?fromgroups#!topic/linux.kernel/iSUDr94Qehc

The changes in this version are:

  * fix commit log typo;
  * prevent a race in via_cputemp_exit;
  * and a new patch that prevents races during init/exit in
    drivers/hwmon/coretemp.c.

Silas
