Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2EGQT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:19:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50336 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab2EGQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:19:58 -0400
Message-ID: <4FA7F628.602@wwwdotorg.org>
Date: Mon, 07 May 2012 10:19:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] i2c: tegra: notify transfer-complete after clearing
 status.
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com> <1336373179-12739-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1336373179-12739-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 12:46 AM, Laxman Dewangan wrote:
> The notification of the transfer complete by calling complete()
> should be done after clearing all interrupt status.
> This may avoid the race condition of misconfigure the i2c controller
> in multi-core environment.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

This patch appears to be independent from the first patch in the series,
so I assume can be checked in immediately.
