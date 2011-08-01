Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1HALMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:12:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51629 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1HALMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:12:05 -0400
Date: Mon, 1 Aug 2011 14:10:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110801111000.GF5575@shale.localdomain>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 12:20:47PM +0200, Manohar Vanga wrote:
> -static int vme_alloc_bus_num(void)
> +/* call with vme_bus_num_mtx held */

Why move the lock outside the function?

> +static int __vme_alloc_bus_num(int bus_num)
>  {

regards,
dan carpenter

