Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1H2XXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:31423 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab1H2XX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="43701317"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Updated direct IO optimization patchkit v3
Date: Mon, 29 Aug 2011 16:23:11 -0700
Message-Id: <1314660202-661-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various micro optimizations of the block direct IO path.

v3: Minor updates from review. Added Acked-bys.

-Andi
