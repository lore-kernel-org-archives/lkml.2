Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab0IUVXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:23:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab0IUVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:23:33 -0400
Date: Tue, 21 Sep 2010 23:23:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: 3m: Convert to MT slots (rev2)
In-Reply-To: <1285099932-4533-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1009212323210.26813@pobox.suse.cz>
References: <1285099932-4533-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Henrik Rydberg wrote:

> The Microtouch controller is capable of doing finger tracking on
> up to 60 fingers. To reduce bandwidth and cpu usage, convert the
> driver to use the MT slots protocol. On Stephane's suggestion, also
> insert the additional copyright lines.
> 
> Acked-by: Stephane Chatty <chatty@enac.fr>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> This is the second revision of the patch, containing these changes:
>      - Added copyright lines
>      - Added comment for signal-to-noise rations
>      - Added Stephanes ACK (correctly spelled :-))

Applied, thanks guys.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
