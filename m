Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab2CMTSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:18:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53863 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152Ab2CMTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:18:36 -0400
Date: Tue, 13 Mar 2012 23:18:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] max17042_battery: Use devm_kzalloc() where applicable
Message-ID: <20120313191831.GA2187@oksana.dev.rtsoft.ru>
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
 <1329933982-2529-2-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329933982-2529-2-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:06:20PM +0100, Karol Lewandowski wrote:
> This allows us to simplify probe and exit function.
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
