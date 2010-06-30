Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0F3UDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:03:46 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62396 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0F3UDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:03:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6029"; a="46087637"
Subject: Re: [PATCH 04/33] Removing dead MSM7X00A_IDLE
From: Daniel Walker <dwalker@codeaurora.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christoph Egger <siccegge@cs.fau.de>, David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de,
       Brian Swetland <swetland@google.com>
In-Reply-To: <20100630195933.GD3969@shutemov.name>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	 <c7e75d44aebaaabfdff9cf5fbda54512d0062728.1277911346.git.siccegge@cs.fau.de>
	 <20100630195933.GD3969@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 13:03:31 -0700
Message-ID: <1277928211.30401.39.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 22:59 +0300, Kirill A. Shutemov wrote:
> On Wed, Jun 30, 2010 at 05:55:03PM +0200, Christoph Egger wrote:
> > MSM7X00A_IDLE doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> 
> It was removed in commit 1637de0c9. I'm not sure if it's correct.
> 
> Brian Swetland added to CC list.

Yeah, it looks like it was missed in the original commit.

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

