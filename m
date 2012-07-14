Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab2GNITj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 04:19:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38411 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2GNITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 04:19:36 -0400
Date: Sat, 14 Jul 2012 01:17:34 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: move lp8727 header into platform_data directory
Message-ID: <20120714081734.GA1633@lizard>
References: <A874F61F95741C4A9BA573A70FE3998FCCD7@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FCCD7@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 01:19:03AM +0000, Kim, Milo wrote:
> The lp8727 header can be used only in the platform side,
> so it can be moved to the platform_data directory.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
