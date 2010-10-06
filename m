Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab0JFLY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:24:58 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52650 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0JFLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:24:56 -0400
Date: Wed, 6 Oct 2010 20:24:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] arm/shmobile: remove duplicated include
Message-ID: <20101006112452.GF15712@linux-sh.org>
References: <20101004122436.7092868f@absol.kitzblitz> <20101004123929.094848ba@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004123929.094848ba@absol.kitzblitz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 12:39:29PM +0200, Nicolas Kaiser wrote:
> Remove duplicated include.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  arch/arm/mach-shmobile/board-ap4evb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
Applied, thanks.
