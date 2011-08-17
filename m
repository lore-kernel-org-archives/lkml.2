Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1HQTmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:42:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65231 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1HQTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:42:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111048364"
Date: Wed, 17 Aug 2011 14:42:13 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 00/36] Hexagon: Add support for Qualcomm Hexagon
 architecture
Message-ID: <20110817194213.GB2694@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org>
 <1313607653.7431.3.camel@knife>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313607653.7431.3.camel@knife>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 01:00:44PM -0600, Zan Lynx wrote:
> I am curious about the hypervisor layer.
> 
> I can guess that it's an attempt to abstract away low level hardware
> changes, a sort of software version of CPU microcode.
> 
> Or maybe it's a Transmeta kind of thing with dynamic recompilation into
> a quickly evolving VLIW instruction set.
> 
> But what's the real reason?

There are definitely opportunities for bonus features with hypervisors,
but the real reason is just to allow multiple guests to run concurrently
on a machine.

Thanks,
Richard Kuo

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
