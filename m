Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2FMBhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:37:32 -0400
Received: from linux-sh.org ([111.68.239.195]:33933 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab2FMBhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:37:31 -0400
Date: Wed, 13 Jun 2012 10:37:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Kill off last dead UBC header
Message-ID: <20120613013724.GL10170@linux-sh.org>
References: <1339188557.30984.10.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339188557.30984.10.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:49:17PM +0200, Paul Bolle wrote:
> Commit 7025bec9125b0a02edcaf22c2dce753bf2c95480 ("sh: Kill off dead UBC
> headers.") skipped arch/sh/include/cpu-sh2a/cpu/ubc.h. Since nothing is
> using that header either, kill it off too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks.
