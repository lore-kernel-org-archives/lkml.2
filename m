Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1HKJqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:46:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57261 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab1HKJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:46:17 -0400
Date: Thu, 11 Aug 2011 12:44:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Paul Moore <paul@paul-moore.com>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netlabel/netlabel_kapi.c: add missing cleanup code
Message-ID: <20110811094407.GG3777@shale.localdomain>
References: <1313055633-25327-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313055633-25327-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 11:40:33AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use the same cleanup code for the failure of kzalloc as for the failure of
> kstrdup just below.
> 

That doesn't work.  The kfree(entry->domain) would cause an oops.

regards,
dan carpenter

