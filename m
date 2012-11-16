Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2KPSZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:25:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39283 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2KPSZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:25:14 -0500
Message-ID: <1353090276.10872.84.camel@cumari.coelho.fi>
Subject: Re: [PATCH 14/14] wlcore: Remove redundant check on unsigned
 variable
From: Luciano Coelho <coelho@ti.com>
To: Tushar Behera <tushar.behera@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Date: Fri, 16 Nov 2012 20:24:36 +0200
In-Reply-To: <1353048646-10935-15-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
	 <1353048646-10935-15-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 12:20 +0530, Tushar Behera wrote:
> No need to check whether unsigned variable is less than 0.
> 
> CC: Luciano Coelho <coelho@ti.com>
> CC: linux-wireless@vger.kernel.org
> CC: netdev@vger.kernel.org
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---

Applied in the wl12xx.git tree.  Thanks!

--
Luca.

