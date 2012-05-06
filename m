Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2EFD3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:29:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41892 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2EFD3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:29:24 -0400
Date: Sat, 5 May 2012 20:27:59 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max17042_battery: Add support for max17047/50 chip
Message-ID: <20120506032759.GH29576@lizard>
References: <1336208666-17810-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336208666-17810-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 02:34:26PM +0530, Ramakrishna Pallala wrote:
> max17047 is improved version of max17042 chip. It has few HW bug
> fixes with minor changes in register set.
> 
> max17050 is same as max17047 chip except its silicon packging. So from
> driver's point of view there is no difference btw max1047 and max1050.
> 
> This patch adds the support to dynamically detect the chip type and
> adds steps to initialize the max17047 chip.
> 
> This patch is generated on top of the following patch:
> [PATCH] max17042_battery: Handle irq request failure case
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
