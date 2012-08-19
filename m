Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2HSJ0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 05:26:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51474 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2HSJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 05:26:40 -0400
Date: Sun, 19 Aug 2012 12:26:34 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 6/8] UBI: replace MTD_UBI_BEB_LIMIT with module
 parameter
Message-ID: <20120819122634.252f1ea5@pixies.home.jungo.com>
In-Reply-To: <1345214124-5478-7-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	<1345214124-5478-7-git-send-email-richard.genoud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Fri, 17 Aug 2012 16:35:22 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
> +		      "MTD devices may be specified by their number, name, or path to the MTD character device node.\n"
> +		      "Optional \"vid_hdr_offs\" parameter specifies UBI VID header position to be used by UBI. (default value if 0 or not set)\n"
> +		      "Optional \"max_beb_per1024\" parameter specifies the maximum expected bad eraseblock per 1024 eraseblocks. (default value ("
> +		      __stringify(CONFIG_MTD_UBI_BEB_LIMIT) ") if 0 or not set)\n"

Looks like "mtd=/dev/mtd1,,25" is invalid, although we state "default
value if 0 or not set".

Also, lines are exceeding 80 chars, not sure this is more readable than
if they were broken.

Regards,
Shmulik
