Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab1CWMuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:50:51 -0400
Received: from fifo99.com ([67.223.236.141]:45235 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679Ab1CWMut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:50:49 -0400
Subject: Re: [PATCH] msm: iommu: Use relaxed register access functions
From: Daniel Walker <dwalker@fifo99.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1300392119-8062-1-git-send-email-stepanm@codeaurora.org>
References: <1300392119-8062-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 05:50:47 -0700
Message-ID: <1300884647.6117.6.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 13:01 -0700, Stepan Moskovchenko wrote:
> Use the relaxed versions of readl/writel for IOMMU register
> access, inserting barriers where appropriate.

Could you provide comments on why you need barriers in the various
places you've placed them.

Daniel

