Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1HIGqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 02:46:30 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58679 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1HIGq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 02:46:29 -0400
Date: Mon, 8 Aug 2011 23:46:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Eric Miao <eric.miao@linaro.org>, Sammy He <r62914@freescale.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: mma8450 - fix module device table type
Message-ID: <20110809064621.GA8017@core.coreip.homeip.net>
References: <1312726487.7287.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312726487.7287.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 10:14:47PM +0800, Axel Lin wrote:
> The module device table for of_device_id should use "of" type.
> 

Applied, thanks Axel.

-- 
Dmitry
