Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2KULou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:44:50 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11351 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab2KULot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:44:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAnAIS9rFB8qHg4PGdsb2JhbAANN4YghDq3fgMBAQEBOIJSAQEBBCNWEAsYAgImAgJDFLNhcJMCgSKMToIUgRMDqUI
Subject: Re: BUG at kernel/timer.c:1100 when using JFFS2
From: Nathan Williams <nathan@traverse.com.au>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1353496126.2378.6.camel@laptop>
References: <1353483457.9160.26.camel@laptop>
	 <1353484194.2701.5.camel@sauron.fi.intel.com>
	 <1353496126.2378.6.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Nov 2012 22:44:47 +1100
Message-ID: <1353498287.2378.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-21 at 22:08 +1100, Nathan Williams wrote:
> On Wed, 2012-11-21 at 09:49 +0200, Artem Bityutskiy wrote:
> > You probably use 3.5? There was a bug which was fixed, try the latest
> > stable 3.5 version, the fix must be there.
> > 
> 
> No I'm using 3.6.  Do you know what the patch was so I can look it up?
> 
Ok I'll try 3.6.7.  "JFFS2: fix unmount regression" seems to be your
patch.  Thanks for your help.

Regards,
Nathan

