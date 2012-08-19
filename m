Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2HSXd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 19:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab2HSXct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 19:32:49 -0400
Subject: Re: [PATCH 04/11] C6X: defconfig: Remove CONFIG_MISC_DEVICES
From: Mark Salter <msalter@redhat.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Sun, 19 Aug 2012 19:32:41 -0400
In-Reply-To: <1345307035-3545-4-git-send-email-festevam@gmail.com>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
	 <1345307035-3545-4-git-send-email-festevam@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1345419163.2750.71.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 13:23 -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
> CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
> as well
> 
> Cc: Mark Salter <msalter@redhat.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---

Acked-by: Mark Salter <msalter@redhat.com>


