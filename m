Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0LCOnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:43:35 -0500
Received: from kroah.org ([198.145.64.141]:45613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0LCOne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:43:34 -0500
Date: Fri, 3 Dec 2010 06:44:12 -0800
From: Greg KH <greg@kroah.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/vme_user: add missing calls to vme_master_free
 calls in .remove
Message-ID: <20101203144412.GA32222@kroah.com>
References: <1288055476-19438-26-git-send-email-cota@braap.org>
 <20101203142051.17155.30135.stgit@ES-BJ21R4J>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203142051.17155.30135.stgit@ES-BJ21R4J>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 02:20:51PM +0000, Martyn Welch wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>
> Acked-by: Martyn Welch <martyn.welch@ge.com>
> ---

Does this need to be in .37 or can it wait for .38?

thanks,

greg k-h
