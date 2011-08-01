Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1HAS5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:57:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19818 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1HAS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:57:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6425"; a="107358344"
Date: Mon, 1 Aug 2011 11:57:45 -0700
From: Larry Bassel <lbassel@codeaurora.org>
To: Larry Bassel <lbassel@codeaurora.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: questions about memory hotplug
Message-ID: <20110801185745.GC3466@labbmf-linux.qualcomm.com>
References: <20110729221230.GA3466@labbmf-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729221230.GA3466@labbmf-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jul 11 15:12, Larry Bassel wrote:
> 
> Would CONFIG_ARCH_POPULATES_NODE_MAP help here? Does anyone
> use this? It doesn't seem to be in any defconfig or Kconfig

I want to clarify this, I meant used on ARM -- I see it is being used
on other architectures (and that movablecore= and kernelcore=
require this config option).

> on 3.0 (or earlier versions I've looked at).
> 

Larry

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
