Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0HPT1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:27:37 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:43126 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756046Ab0HPT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:27:36 -0400
Date: Mon, 16 Aug 2010 15:27:25 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1: WARNING when loading ehci-hcd module
Message-ID: <20100816192725.GA2404@elliptictech.com>
Mail-Followup-To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org
References: <20100816184515.GA3247@elliptictech.com>
 <20100816190241.GA6785@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816190241.GA6785@arch.tripp.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-16 21:02 +0200, Markus Trippelsdorf wrote:
> The problem is already fixed:
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2
> 
> I guess the patch will reach mainline in the next days.

Wonderful.  I cherry-picked this and things seem to be working now,
thanks.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
