Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab1IIS6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:58:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9489 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460Ab1IIS6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:58:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6464"; a="117149421"
Date: Fri, 9 Sep 2011 13:57:58 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v3 17/36] Hexagon: Add interrupts
Message-ID: <20110909185758.GA2034@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
 <20110909010916.327107063@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909010916.327107063@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 08:09:04PM -0500, Richard Kuo wrote:
> Removed init_IRQ wrapper and fixed up some comments.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

This should have a 
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

since I think I wrote about 100% of some of these files... 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
