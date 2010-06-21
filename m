Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab0FUMFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:05:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:42952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0FUMFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:05:05 -0400
Date: Mon, 21 Jun 2010 14:05:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fixing offset errors in bin_attribute read functions
 of roccat kone
In-Reply-To: <1277054346.10971.1.camel@localhost>
Message-ID: <alpine.LNX.2.00.1006211404560.13809@pobox.suse.cz>
References: <1277054346.10971.1.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, Stefan Achatz wrote:

> Fixing wrong calculated offsets in bin_attribute read functions.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
