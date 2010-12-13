Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0LMQfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:35:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55426 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab0LMQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:35:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6195"; a="66623205"
Date: Mon, 13 Dec 2010 08:35:11 -0800
From: David Brown <davidb@codeaurora.org>
To: ykaoua@qualcomm.com, Jeff Ohlstein <johlstei@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>
Subject: Re: [PATCH 0/5 v3] SMP support for msm
Message-ID: <20101213163511.GA10659@huya.qualcomm.com>
References: <1292203221-2609-1-git-send-email-y>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292203221-2609-1-git-send-email-y>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:20:15PM -0800, ykaoua@qualcomm.com wrote:
> From: Jeff Ohlstein <johlstei@codeaurora.org>
> 
> This series adds support for SMP on msm targets, and specifically adds
> support for SMP on the msm8x60. This version is rebased on top of
> Russell's SMP and gic patches, and doesn't need to change dma-mapping.

Heh.  These are supposed to be from Jeff Ohlstein, not ykaoua.  Jeff,
when you incorporate fixes, please make sure the series gets sent from
your address.

Yvonne, apologies that you'll be getting all of the replies to this
thread, please ignore them.

As far as I can tell, what happened is that 'git send-email' asks to
confirm the email address.  It's not a question, so if you type 'y',
it happily sends the email from 'y', which in our case expands to the
ykaoua user.

David
