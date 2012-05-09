Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2EIWSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:18:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab2EIWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:18:14 -0400
Date: Wed, 9 May 2012 15:18:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: arnd@arndb.de, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
Message-ID: <20120509221810.GA17417@kroah.com>
References: <1336534304-26273-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336534304-26273-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 12:31:44PM +0900, Chanwoo Choi wrote:
> This patchset use Extcon framework in extcon-max8997 driver to control
> external connector instead of max8997-muic driver which is implemented
> with callback function through platform_data to control external connector.
> 
> So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
> the last patch remove previous MAX8997 MUIC driver(drivers/misc/max8997-muic.c)
> which support MUIC feature of Maxim MAX8997 with callback function.

Nice job, all applied now.

greg k-h
