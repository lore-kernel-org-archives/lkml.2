Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1HSRNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:13:36 -0400
Received: from void.printf.net ([89.145.121.20]:52515 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab1HSRNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:13:33 -0400
From: Chris Ball <cjb@laptop.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-mmc@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mmc: fixes for aggressive clock gating framework
References: <cover.1313664897.git.mika.westerberg@linux.intel.com>
Date: Fri, 19 Aug 2011 13:13:26 -0400
In-Reply-To: <cover.1313664897.git.mika.westerberg@linux.intel.com> (Mika
	Westerberg's message of "Thu, 18 Aug 2011 15:23:46 +0300")
Message-ID: <m2zkj5miix.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Thu, Aug 18 2011, Mika Westerberg wrote:
> Hi,
>
> This is an updated series which should fix few races seen when aggressive
> clock gating is active. The first patch actually just renames the gating
> functions to make their use-cases a bit more clear.

Thanks very much!  Pushed to mmc-next for 3.1-rc.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
