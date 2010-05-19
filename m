Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0ESWef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:34:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56407 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0ESWee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:34:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5987"; a="41994184"
Subject: Re: [PATCH] msm_serial: fix serial on trout
From: Daniel Walker <dwalker@codeaurora.org>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brian Swetland <swetland@google.com>, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274286935-8474-1-git-send-email-adharmap@codeaurora.org>
References: <1274286935-8474-1-git-send-email-adharmap@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 15:34:24 -0700
Message-ID: <1274308464.22641.31.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 09:35 -0700, Abhijeet Dharmapurikar wrote:
> All targets report the correct uartclk except trout.
> For trout force mnd counter values as if uartclk was
> fed by tcxo/4. For other targets set the mnd counter
> based on uartclk.

Can you be more specific in the description here. It sounds like your
fixing a problem with trout serial, but trout serial works fine.

Daniel

