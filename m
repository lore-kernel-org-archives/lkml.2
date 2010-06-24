Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0FXKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:12:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49857 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab0FXKL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:11:58 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: mel@csn.ul.ie, dwalker@codeaurora.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [RFC] mm: iommu: An API to unify IOMMU, CPU and device memory management
References: <1277355096-15596-1-git-send-email-zpfeffer@codeaurora.org>
Date: Thu, 24 Jun 2010 12:11:56 +0200
In-Reply-To: <1277355096-15596-1-git-send-email-zpfeffer@codeaurora.org> (Zach
	Pfeffer's message of "Wed, 23 Jun 2010 21:51:36 -0700")
Message-ID: <876318ager.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Pfeffer <zpfeffer@codeaurora.org> writes:

> This patch contains the documentation for and the main header file of
> the API, termed the Virtual Contiguous Memory Manager. Its use would
> allow all of the IOMMU to VM, VM to device and device to IOMMU
> interoperation code to be refactored into platform independent code.

I read all the description and it's still unclear what advantage
this all has over the current architecture? 

At least all the benefits mentioned seem to be rather nebulous.

Can you describe a concrete use case that is improved by this code
directly?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
