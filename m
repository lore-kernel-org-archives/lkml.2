Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1IGQds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:38324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1IGQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:42 -0400
Date: Wed, 7 Sep 2011 16:40:23 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] fbdev: remove display subsystem
In-Reply-To: <1315013768-3235-1-git-send-email-FlorianSchandinat@gmx.de>
Message-ID: <alpine.LFD.2.00.1109071637220.29700@casper.infradead.org>
References: <1315013768-3235-1-git-send-email-FlorianSchandinat@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This four year old subsystem does not have a single in-tree user
> not even in staging and as far as I know also none out-of-tree.
> I think that justifies removing it which cleans the config up.

The idea was to provide a frame work for text lcd panels, like for example 
the CrystalFontz. Yes no one was interested so I guess having people write 
there own console driver will do.

> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: James Simmons <jsimmons@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Ack-By: James Simmons <jsimmons@infradead.org>

