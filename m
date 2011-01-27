Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1A0Uo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:44:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab1A0Uo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:44:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72238891"
Subject: Re: [PATCH] msm: Clean up useless ifdefs
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1296159202-13980-1-git-send-email-stepanm@codeaurora.org>
References: <1296159202-13980-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 12:44:24 -0800
Message-ID: <1296161064.28965.10.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 12:13 -0800, Stepan Moskovchenko wrote:
> Remove ifdefs that do nothing, either from having the code
> between them previously removed, or from having been
> accidentally added to the wrong file.
> 
> Change-Id: I94aac2cb24e23ba7f8b4b158ce6653dc3b786989
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>

You need to drop the Change-Id: ..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

