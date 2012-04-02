Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2DBVQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:16:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59547 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2DBVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:16:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6668"; a="178199600"
Date: Mon, 2 Apr 2012 14:16:01 -0700
From: David Brown <davidb@codeaurora.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 02/11] ARM: mach-msm: fix compile fail from system.h
 fallout
Message-ID: <20120402211601.GA28311@codeaurora.org>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
 <1333312727-11428-3-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333312727-11428-3-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 04:38:38PM -0400, Paul Gortmaker wrote:

> diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
