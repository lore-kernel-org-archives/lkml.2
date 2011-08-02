Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1HBKPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1HBKPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:15:38 -0400
Date: Tue, 2 Aug 2011 11:15:33 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Thornber <thornber@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110802101533.GQ10499@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
References: <20110802151306.4fb9904e55fe9b489a3cf29d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802151306.4fb9904e55fe9b489a3cf29d@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 03:13:06PM +1000, Stephen Rothwell wrote:
> This really is a bug in the original patch as you should explicitly
> include module.h if you are using the module facilities.

Fixed, thanks.

Alasdair
