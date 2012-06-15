Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2FOMlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:41:36 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43932 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2FOMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:41:34 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -V3 0/4] hugeltb: Fixes for hugetlb controller patches
Date: Fri, 15 Jun 2012 18:11:18 +0530
Message-Id: <1339764082-1611-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12061512-8256-0000-0000-000002EF8C7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This series contain fixes based on review feedback on top of the
hugetlb controller patches already in -mm. Please apply.

-aneesh

