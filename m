Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0GVPBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:01:51 -0400
Received: from THUNK.ORG ([69.25.196.29]:45470 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0GVPBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:01:50 -0400
Date: Thu, 22 Jul 2010 11:01:45 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org,
        Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Subject: Re: openvz: Oops in ext4 when VPS starts
Message-ID: <20100722150145.GE14882@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Drunkard Zhang <gongfan193@gmail.com>, linux-kernel@vger.kernel.org,
	devel@openvz.org, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
References: <AANLkTilaycSLL2dDnXDVs1gCiD0B8K78i2rBdWJGZrRD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilaycSLL2dDnXDVs1gCiD0B8K78i2rBdWJGZrRD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 05:39:16PM +0800, Drunkard Zhang wrote:
> I run into a oops when mirgate /vz directory to ext4 lvm under gentoo + openvz.

What were you doing precisely at the time of the oops?  The oops logs
indicates it was a cp, but a cp of what?  And is this somethign you
can easily reproduce?

					- Ted
