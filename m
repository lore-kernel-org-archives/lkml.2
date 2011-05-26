Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1EZArG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1EZArE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:47:04 -0400
Date: Thu, 26 May 2011 01:46:56 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: failed to fetch the device-mapper tree
Message-ID: <20110526004656.GB872@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110526100407.532d4105.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526100407.532d4105.sfr@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:04:07AM +1000, Stephen Rothwell wrote:
> Fetching the device-mapper tree today filaed like this:
> rsync: change_dir "/pub/linux/kernel/people/agk/patches/2.6/editing/" failed: Permission denied (13)
 
Odd - no error from the upload script log, and rerunning it fixed it.

Alasdair

