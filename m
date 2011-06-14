Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1FNWDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:03:07 -0400
Received: from outmail007.snc4.facebook.com ([66.220.144.139]:60388 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101Ab1FNWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:03:05 -0400
Date: Tue, 14 Jun 2011 15:03:04 -0700
From: Arun Sharma <asharma@fb.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [perf] fix annotation loading when symbol sort order not
 used.
Message-ID: <20110614220304.GA17101@dev1756.snc6.facebook.com>
References: <BANLkTinXzHiCTb6EWWGSJmzz5dS1P9p1sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinXzHiCTb6EWWGSJmzz5dS1P9p1sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 02:09:40AM +0800, Sam Liao wrote:
> When "symbol" is not in "-s" sort order options, the hist entry's
> ms.sym is not equal to sample's addr_location.sym where we should
> not load annotation. This fix check if symbol sort order used, if
> not, disable symbol annonation for report command in tui mode.

Thanks for taking care of this. Works well for me.

 -Arun
