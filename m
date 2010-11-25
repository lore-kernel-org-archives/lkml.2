Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0KYJcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:32:45 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.42]:60427 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab0KYJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:32:43 -0500
Message-ID: <4CEE2D4E.6070906@ladisch.de>
Date: Thu, 25 Nov 2010 10:33:02 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 02/12] media: Media device
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290652099-15102-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> +struct media_device {
> ...
> +	u8 model[32];
> +	u8 serial[40];
> +	u8 bus_info[32];

All drivers and userspace applications have to treat this as char[], so
why u8[]?


Regards,
Clemens
