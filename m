Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1AJVvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:51:31 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:57104 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1AJVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:51:30 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 173.50.155.44
Date: Mon, 10 Jan 2011 13:50:39 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] rcutorture: Get rid of duplicate sched.h include
Message-ID: <20110110215039.GA14492@feather>
References: <alpine.LNX.2.00.1101102141230.32164@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101102141230.32164@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:43:13PM +0100, Jesper Juhl wrote:
> linux/sched.h is included twice in kernel/rcutorture.c - once is enough.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Looks like the duplicate include appeared in
8e8be45e8e55daa381028aec339829929ddb53a5.

- Josh Triplett
