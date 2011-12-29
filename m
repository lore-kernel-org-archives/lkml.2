Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1L2MMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 07:12:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:17773 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab1L2MMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 07:12:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="90521950"
Date: Thu, 29 Dec 2011 12:25:31 +0000
From: Alan Cox <alan@linux.intel.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] staging, gma500: Fix warning in power.c
Message-ID: <20111229122531.08e17846@bob.linux.org.uk>
In-Reply-To: <CADZ9YHiW=RcS2bJd3hgNk+kwtQu5=8wgYM1rqv1EO9pbad7aBA@mail.gmail.com>
References: <1324579605.19018.3.camel@localhost.localdomain>
	<20111228140445.70c11f9c@bob.linux.org.uk>
	<CADZ9YHhORC2N-vs3DjwXnCQCkcTEbieF4xqBxPiXskdZu7WySg@mail.gmail.com>
	<CADZ9YHiW=RcS2bJd3hgNk+kwtQu5=8wgYM1rqv1EO9pbad7aBA@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do I have to resend the patch, prepared against -rc7? Patch is on it's
> way towards mainline through linux-next (Greg took it in his tree
> previously). It might conflict during merging, not sure. If requires I
> can send it again.

What I meant was that the old driver is marked BROKEN for -next (ie
won't be built), and in fact I sent GregKH a request to delete it.

The driver in updated form has moved to drivers/gpu/drm/gma500 in the
-next tree.

Alan
