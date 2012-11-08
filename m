Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2KHREh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:04:37 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38710 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2KHREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:04:36 -0500
Date: Thu, 8 Nov 2012 09:04:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: fix input-mt kernel-doc warning
Message-ID: <20121108170431.GD8877@core.coreip.homeip.net>
References: <5099B45E.8080105@infradead.org>
 <20121107194617.GA3738@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107194617.GA3738@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 08:46:17PM +0100, Henrik Rydberg wrote:
> Hi Randy,
> 
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > Fix new kernel-doc warning in input-mt.c:
> > 
> > Warning(drivers/input/input-mt.c:38): No description found for parameter 'flags'
> 
> Thanks for the patch. It seemed reasonable to expand the function
> documentation a bit as well, hope you are alright with the patch
> below, Dmitry, care to pick this up for 3.7? Otherwise I can carry it
> for 3.8.

Randy, Henrik,

I'll try getting it in 3.7.

Thanks.

-- 
Dmitry
