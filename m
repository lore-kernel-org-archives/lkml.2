Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0LXSiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 13:38:50 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41605 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LXSis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 13:38:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WFcPPBfkJkXKmuMQSr5xDHwhVdFcQUGbH3pdPgth3irakVRnrgWKAH37tnnQ15yeo/
         POY1b9nTCf/VDzhOEzztKi7MbhFV6ErIPFM7ZHJ/xGNCCA/5hKHrup8VPnvOaRh4ZIu1
         /srDiP2asgonqHg/vuUoxNvnYQnXMkZipiUoY=
Message-ID: <4D14E8B3.8070605@pobox.com>
Date: Fri, 24 Dec 2010 13:38:43 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] pata_mpc52xx: driver needs BMDMA
References: <1293033011-19265-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1293033011-19265-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 10:50 AM, Wolfram Sang wrote:
> Found by this build-error if BMDMA is disabled:
>
> drivers/ata/pata_mpc52xx.c: In function 'mpc52xx_ata_init_one':
> drivers/ata/pata_mpc52xx.c:662: error: 'ata_bmdma_interrupt' undeclared (first use in this function)
> ...
>
> Move the Kconfig entry to the proper location as needed since
> 9a7780c9acb821fe1c2b6fc53f74cc2556ff5364 (libata-sff: make BMDMA optional)
>
> Signed-off-by: Wolfram Sang<w.sang@pengutronix.de>
> ---
>
> This is a build-failure, so fixing it before 2.6.37 would be great.
>
>   drivers/ata/Kconfig  |   20 ++++++++++----------
>   drivers/ata/Makefile |    2 +-
>   2 files changed, 11 insertions(+), 11 deletions(-)

applied


