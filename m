Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab1HITpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:45:46 -0400
Received: from science.horizon.com ([71.41.210.146]:26890 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750722Ab1HITpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:45:46 -0400
Date: 9 Aug 2011 15:45:44 -0400
Message-ID: <20110809194544.11518.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        joakim.tjernlund@transmode.se, linux-kernel@vger.kernel.org,
        linux@horizon.com, rdunlap@xenotime.net,
        rpearson@systemfabricworks.com
Subject: RE: [patch v4 1/7] crc32: move-to-documentation.diff
In-Reply-To: <015501cc56b5$30816f00$91844d00$@systemfabricworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks George! I'll replace the document patch with this. Can I add a signed
> off line from you?

Yes, feel free.  With the << vs. >> typo fix.

Another minor point: is it worth cache line aligning the tables?
The cache occupancy savings is minimal (two partial cache lines at
the beginning and end of the tables), but does ensure that lookups
in adjoining tables will never need the same cache line.  Is that a
performance win?
