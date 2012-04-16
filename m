Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab2DPQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:03:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55642 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2DPQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:03:37 -0400
Message-ID: <4F8C42D6.2000607@wwwdotorg.org>
Date: Mon, 16 Apr 2012 10:03:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1334586289-13078-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 08:24 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Remove dummy state user interface and handle it totally in core.
> This can make it more easy to use by platforms which has neither pinctrl
> driver support nor dt support.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

I think this is the wrong direction.

I specifically want people to think about which drivers require what
pinctrl states to be defined, and what their content should be, and
hence explicitly define dummy states when it's appropriate. This patch
prevents that.
