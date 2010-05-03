Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab0ECN22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:28:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:54206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975Ab0ECN2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:28:21 -0400
Date: Mon, 3 May 2010 15:28:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nicu Pavel <npavel@ituner.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH 2/2] hid: add PM support to PicoLCD device
In-Reply-To: <20100502160505.4acc9f1c@neptune.home>
Message-ID: <alpine.LNX.2.00.1005031527350.9849@pobox.suse.cz>
References: <20100425214003.7e87c6a3@neptune.home> <20100425214306.5d7be049@neptune.home> <alpine.LNX.2.00.1004271525330.9849@pobox.suse.cz> <20100427221648.39735c41@neptune.home> <alpine.LNX.2.00.1004272256160.9849@pobox.suse.cz>
 <20100502160505.4acc9f1c@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 May 2010, Bruno Prémont wrote:

> Ok, below is an updated patch, which also adds missing 'inline' keyword
> for a few stubs and replaces #define f(a,b) to nothing with equivalent
> stubs.

Looks good to me, I have applied the patch. Thanks Bruno.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
