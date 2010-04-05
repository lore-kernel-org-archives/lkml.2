Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0DEOCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:02:24 -0400
Received: from 8bytes.org ([88.198.83.132]:56689 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668Ab0DEOCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:02:16 -0400
Date: Mon, 5 Apr 2010 16:02:15 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Dan Carpenter <error27@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] dma-debug: off by one issue
Message-ID: <20100405140215.GA29758@8bytes.org>
References: <20100402112843.GI5265@bicker> <20100403204717.GS24846@8bytes.org> <20100405125329.GA16197@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405125329.GA16197@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 03:53:30PM +0300, Dan Carpenter wrote:
> On Sat, Apr 03, 2010 at 10:47:17PM +0200, Joerg Roedel wrote:

> > The character is already reserved by the user-to-kernel copy earlier in
> > the function.
> 
> Yes, but the original code requires more code reading to audit. Let's 
> change the commit message to say that it's a clean up patch.

In this case its better to remove the

	current_driver_name[i] = 0;

line just after the loop.

	Joerg

