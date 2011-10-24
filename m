Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1JXTWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1JXTWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:22:44 -0400
Date: Mon, 24 Oct 2011 20:22:39 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: failed to import the device-mapper quilt series
Message-ID: <20111024192239.GA18667@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20111025061010.26d2b727559242a5d188918e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025061010.26d2b727559242a5d188918e@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 06:10:10AM +1100, Stephen Rothwell wrote:
> And indeed, this file does not exist even though this patch is trying to
> patch it (not create it).

Hmmm.  Yes, that patch is corrupted.  I'll regenerate it.

Alasdair

