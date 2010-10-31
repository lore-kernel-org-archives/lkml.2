Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0JaHdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:33:16 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:56660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0JaHdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:33:14 -0400
Subject: Re: [PATCH 37/39] net/mac80211: Update WARN uses
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <de75963e04701e309b86dfee54c36e11873048c2.1288471898.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
	 <de75963e04701e309b86dfee54c36e11873048c2.1288471898.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 08:33:01 +0100
Message-ID: <1288510381.3839.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 14:08 -0700, Joe Perches wrote:
> Coalesce long formats.
> Add missing newlines.

> -			WARN(1, "frame for unexpected interface type");
> +			WARN(1, "frame for unexpected interface type\n");

But I thought WARN() added a newline...

johannes

