Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2KLQNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:13:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35070 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2KLQNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:13:09 -0500
Message-ID: <50A12012.7040203@wwwdotorg.org>
Date: Mon, 12 Nov 2012 09:13:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra: Staticize non-exported symbols
References: <1352601091.23129.7.camel@phoenix>
In-Reply-To: <1352601091.23129.7.camel@phoenix>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2012 07:31 PM, Axel Lin wrote:
> They are not referenced outside of this file, make them static.

Acked-by: Stephen Warren <swarren@nvidia.com>
