Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2GAXAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 19:00:01 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56209 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2GAW77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 18:59:59 -0400
Date: Sun, 1 Jul 2012 17:59:50 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Boot <bootc@bootc.net>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [ 15/48] e1000e: Remove special case for 82573/82574 ASPM  L1
 disablement
Message-ID: <20120701225950.GD3728@burratino>
References: <20120701172006.535271340@decadent.org.uk>
 <20120701172008.810233261@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701172008.810233261@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Chris Boot <bootc@bootc.net>
>
> commit 59aed95263bdd0e2b48eb9be5a94346d2d4abf90 upstream.

This patch still seems both lovely and unnecessary, and I would prefer
that it not be part of 3.2-stable.  If I understood the replies before,
it is safe to drop it, right?

Thanks,
Jonathan
