Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab0JFTfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:35:46 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54549 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0JFTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:35:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6128"; a="56950538"
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <4CACC053.2090509@codeaurora.org>
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
	 <1285644827-6846-2-git-send-email-sboyd@codeaurora.org>
	 <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com>
	 <4CABEECB.4030301@codeaurora.org>
	 <alpine.LFD.2.00.1010061024220.3107@xanadu.home>
	 <4CACC053.2090509@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 12:35:43 -0700
Message-ID: <1286393743.22265.129.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 11:30 -0700, Stephen Boyd wrote:
> Is there some way to force GCC to do what I want (interleave the
> functions)? It seems happy to inline them and then optimize the
> register
> usage and instruction ordering. Perhaps that is OK though and we're
> wasting our time trying to be conservative in code size. 

Is it possible to do all this in assembly ? Can't you have the default
implementation using this assembly with different function names, then
just set the assembly function names in C code someplace?

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


