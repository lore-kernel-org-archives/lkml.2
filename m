Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1ERXS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:18:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621Ab1ERXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:18:28 -0400
Date: Wed, 18 May 2011 16:18:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        <richard.purdie@linuxfoundation.org>, <rpurdie@rpsys.net>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH] leds: add regulator to lm3530 driver
Message-Id: <20110518161814.8e79efab.akpm@linux-foundation.org>
In-Reply-To: <1305550078-28389-1-git-send-email-shreshthakumar.sahu@stericsson.com>
References: <1305550078-28389-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 18:17:58 +0530
Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com> wrote:

> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

No changelog.  We can't think of anything which we can add to help
people understand what the patch does and why it does it?

Has this been runtime tested with CONFIG_REGULATOR=n?
