Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1CUQJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:09:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1CUQJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:09:16 -0400
Date: Mon, 21 Mar 2011 17:09:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Migrations to hid-multitouch, round 3 
In-Reply-To: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1103211707520.19969@pobox.suse.cz>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, Benjamin Tissoires wrote:

> This is the third version for this patch series.
> 
> Since last time, I mainly modified the patch #1 to adapt
> Henrik's comments. I also added #4 as the code path was confusing.

Thanks a lot to everyone for working on this.

I have applied all the patches except for 5/5, where Henrik has reported 
problems with testing against 1968 model. The problem hasn't been 
understood/debugged yet.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
