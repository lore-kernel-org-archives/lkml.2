Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0D2Dhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:37:37 -0400
Received: from kroah.org ([198.145.64.141]:37474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab0D2Dhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:37:36 -0400
Date: Wed, 28 Apr 2010 20:36:25 -0700
From: Greg KH <greg@kroah.com>
To: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] Mobile security processor driver
Message-ID: <20100429033625.GA27503@kroah.com>
References: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:10:34PM -0700, Epshteyn, Eugene wrote:
> >From ea67f69e70e5a8c6e50db3f1d8b62cd52d816bc6 Mon Sep 17 00:00:00 2001
> From: Mark Allyn <mark.a.allyn@intel.com>
> Date: Wed, 28 Apr 2010 14:33:16 -0700
> Subject: RFC [PATCH 1/4] staging: sep: header file updates for 12/09 software release
> 
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>

Why are you posting Mark's patches?

There is no description of what these patches actually do.

Are you wanting them to be applied?

Why have you listed all of the patches with the same subject?

What exactly are you expecting to happen here?

totally confused,

greg k-h


p.s., I think this patch is completly wrong, based on one part:

> @@ -25,401 +31,576 @@
>    *
>    *  CHANGES:
>    *
> - *  2009.06.26 Initial publish
> + *  2010.01.08 Initial publish

the code was already published, this can't be an "initial publication"
again :)

What did you diff these against?
