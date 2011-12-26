Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1LZOYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 09:24:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53620 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab1LZOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 09:23:58 -0500
Date: Mon, 26 Dec 2011 14:23:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, Samuel Ortiz <sameo@linux.intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: devm_kfree
Message-ID: <20111226142354.GI8722@opensource.wolfsonmicro.com>
References: <1324661974-17281-1-git-send-email-julia@diku.dk>
 <20111226120855.GB17760@sirena.org.uk>
 <alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 02:44:58PM +0100, Julia Lawall wrote:
> Is it reasonable to use devm_kfree in a probe function that fails or
> a remove function that succeeds?

If we need to do this I'd suggest that we should be fixing the manager
to not need it rather than having drivers do this.
