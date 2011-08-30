Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1H3Wyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:54:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19738 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1H3Wyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:54:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113940325"
Date: Tue, 30 Aug 2011 15:54:33 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Removing msm tree from direct linux-next
Message-ID: <20110830225433.GA7138@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, now that the MSM tree is going through Arnd's ARM SOC tree,
it doesn't need to be pulled directly into linux-next.  You can remove
this tree:

msm git://codeaurora.org/quic/kernel/davidb/linux-msm.git#for-next

Thanks,
David Brown

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
