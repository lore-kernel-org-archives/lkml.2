Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1BXP4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:56:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51874 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1BXP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:56:15 -0500
Date: Thu, 24 Feb 2011 08:56:11 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, error27@gmail.com
Subject: Re: [PATCH v3] gpio: Fix wrong pointer type in pca953x
Message-ID: <20110224155611.GA17735@angua.secretlab.ca>
References: <20110222123601.GA1966@bicker>
 <1298539243-25150-1-git-send-email-eibach@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298539243-25150-1-git-send-email-eibach@gdsys.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:20:43AM +0100, Dirk Eibach wrote:
> pca953x_get_alt_pdata() uses uint16_t* as result type for
> of_get_property(), but numeric of values are __be32.
> 
> Checking for negative values is bogus because of-property
> values are unsigned by definition.
> Instead check for proper property size.
> 
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>

Applied, thanks.

g.

