Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1CVGPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 02:15:10 -0400
Received: from linux-sh.org ([111.68.239.195]:51479 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab1CVGPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 02:15:07 -0400
Date: Tue, 22 Mar 2011 15:14:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/13] omap: use list_move() instead of list_del()/list_add() combination
Message-ID: <20110322061425.GC25925@linux-sh.org>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name> <1300229605-14499-7-git-send-email-kirill@shutemov.name> <1300229605-14499-1-git-send-email-kirill@shutemov.name> <1300229605-14499-6-git-send-email-kirill@shutemov.name> <1300275829.1917.94.camel@lappyti>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300229605-14499-7-git-send-email-kirill@shutemov.name> <1300275829.1917.94.camel@lappyti>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:13:49PM +0530, Tomi Valkeinen wrote:
> On Tue, 2011-03-15 at 17:53 -0500, Kirill A. Shutemov wrote:
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
> > Cc: linux-fbdev@vger.kernel.org
> > Cc: linux-omap@vger.kernel.org
> > ---
> >  drivers/video/omap/blizzard.c |    3 +--
> >  drivers/video/omap/hwa742.c   |    3 +--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

On Wed, Mar 16, 2011 at 12:53:19AM +0200, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/vermilion/vermilion.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
Both applied, thanks.
