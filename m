Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1FGNsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:48:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:55013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab1FGNss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:48:48 -0400
Date: Tue, 7 Jun 2011 15:48:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>
Subject: Re: [PATCHv3] hid: Fix Logitech Driving Force Pro wheel
In-Reply-To: <1307054414-19239-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1106071548230.22872@pobox.suse.cz>
References: <20110603112510.18482vx63j4ygmm8@webmail.df.eu> <1307054414-19239-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011, Simon Wood wrote:

> Changes from initial patch:
> - shorten comment (removed original descriptor)
> - optimized new descriptor (simpler and shorter)
> - resent by Simon to fix patch for 3.0rc1

I have applied the patch (with Michael's authorship metadata). Thanks 
guys,

-- 
Jiri Kosina
SUSE Labs
