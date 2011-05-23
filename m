Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1EWHNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:13:30 -0400
Received: from linux-sh.org ([111.68.239.195]:47580 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1EWHN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:13:29 -0400
Date: Mon, 23 May 2011 16:13:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: anish <anish198519851985@gmail.com>
Cc: linux@arm.linux.org.uk, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] trivial: amba-clcd.c preferred form of passing size of structure
Message-ID: <20110523071301.GK5206@linux-sh.org>
References: <1305742026.8771.26.camel@anish-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305742026.8771.26.camel@anish-desktop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:37:06PM +0530, anish wrote:
> The preferred form for passing a size of a struct is the following:
>          p = kmalloc(sizeof(*p), ...);
>   Please refer Documentation/Codingstyle chapter 14
> 
>  Signed-off-by: anish kumar <anish198519851985@gmail.com>
> 
That's pretty subjective, and ultimately depends on the author. I
personally prefer to have it written out, but then I don't randomly
change my structure types around either, so the "bug" alluded to isn't
really an issue. I'm not sure I buy the impaired readability argument,
either..
