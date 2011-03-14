Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1CNMIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:08:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab1CNMIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:08:42 -0400
Date: Mon, 14 Mar 2011 13:08:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Migrations to hid-multitouch, round 2 
In-Reply-To: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1103141307590.19969@pobox.suse.cz>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011, Benjamin Tissoires wrote:

> Hi guys,
> 
> This is the second version for this patch series.
> 
> Since last time, I integrated Henrik's comments.
> 
> Cheers,
> Benjamin
> 
>  drivers/hid/Kconfig          |   21 +---
>  drivers/hid/Makefile         |    3 -
>  drivers/hid/hid-3m-pct.c     |  305 ------------------------------------------
>  drivers/hid/hid-cando.c      |  276 --------------------------------------
>  drivers/hid/hid-multitouch.c |  110 +++++++++++++---
>  drivers/hid/hid-stantum.c    |  286 ---------------------------------------
>  6 files changed, 97 insertions(+), 904 deletions(-)
> 
> ;-)

Hi Benjamin,

thanks a lot for this work you have done.

Is there going to be second round of the patches with a few minor fixes 
coming out from Henrik's review?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
