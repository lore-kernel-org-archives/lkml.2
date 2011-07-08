Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1GHNTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:19:37 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58043 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1GHNTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:19:36 -0400
Date: Fri, 8 Jul 2011 17:19:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: MAX17042: Support additional properties
Message-ID: <20110708131931.GB1008@oksana.dev.rtsoft.ru>
References: <1309169096-1447-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1309169096-1447-1-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 07:04:56PM +0900, Donggeun Kim wrote:
> This patch supports additional properties (PRESENT, CYCLE_COUNT,
> VOLTAGE_MAX, VOLTAGE_MIN_DESIGN, CURRENT_NOW, CURRENT_AVG,
> CHARGE_FULL, and TEMP).
> Plus, initialization code for registers is added.
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> ---

Applied, thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
