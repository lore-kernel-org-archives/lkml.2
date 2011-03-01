Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1CATlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:41:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab1CATlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vu33YUiCIQnBzZgr54feAMhQmkJ9srB4xmzWdgC2t3EEC/hZibcW7Fzj1xJiisKDwi
         rzyUJla2NTpNGIFTAuIm9wcyOdya7teY1sPgNWb3fEhXQNDt+C70kx5Mkr187UM7YVro
         T9hChjA988cQ21sGQb/QiCSOSU+VXz/Podpqs=
Date: Tue, 1 Mar 2011 22:41:27 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] power: bq20z75: update support
Message-ID: <20110301194127.GC5649@oksana.dev.rtsoft.ru>
References: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:55:27PM -0800, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> Adds support to driver for the following:
> * optional gpio for battery detection
> * optional retries for i2c I/O failures
> * POWER_NOW property
> 
> For more detailed information, see specifics patches.
> 
> Rhyland Klein (4):
>   power: bq20z75: add optional battery detect gpio
>   power: bq20z75: add i2c retry mechanism
>   power: bq20z75: add support for POWER_NOW
>   power_supply: update power_supply_is_watt_property

You're fast! :-)

Applied all the patches, modulo "add support for POWER_NOW".

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
