Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1G0PEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:04:33 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35056 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab1G0PEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:04:31 -0400
Date: Wed, 27 Jul 2011 11:04:28 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCHv3 2/2] ARM: P2V: Remove ARM_PATCH_PHYS_VIRT_16BIT
In-Reply-To: <20110727145330.GA32004@huya.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1107271102370.12766@xanadu.home>
References: <1311733255-25207-1-git-send-email-sboyd@codeaurora.org> <1311733255-25207-2-git-send-email-sboyd@codeaurora.org> <20110727145330.GA32004@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, David Brown wrote:

> On Tue, Jul 26, 2011 at 07:20:55PM -0700, Stephen Boyd wrote:
> > From: Nicolas Pitre <nicolas.pitre@linaro.org>
> > 
> > Now that MSM targets no longer need the 16-bit offsets for P2V, this
> > code can be removed.
> > 
> > Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> I've tested this on MSM, but without an actual offset.  It'd be good
> to test this on a target with an actual adjustment being used, to make
> sure nothing breaks.

Unless your RAM is physically located at 0xc0000000, you do end up 
having an offset already.


Nicolas
