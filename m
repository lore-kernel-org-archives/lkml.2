Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0IUOMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:12:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:57406 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab0IUOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:12:36 -0400
Date: Tue, 21 Sep 2010 16:12:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH] hid: Add a hid quirk for input sync override
In-Reply-To: <1282640084-19217-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1009211612100.26813@pobox.suse.cz>
References: <1282640084-19217-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Henrik Rydberg wrote:

> From: Henrik Rydberg <rydberg@thabit.(none)>
> 
> As of lately, HID devices which send per-frame data split over several
> HID reports have started to emerge. This patch adds a quirk which
> allows the HID driver to take over the input layer synchronization,
> and hence the control of the frame boundary.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied, thanks (into 3m branch, as 3m patches depend on this).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
