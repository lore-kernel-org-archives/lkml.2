Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2AZHHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 02:07:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59643 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab2AZHHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 02:07:47 -0500
Date: Thu, 26 Jan 2012 07:07:45 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <CA+55aFxTAHTXRmnK9AeJm525u28SGRxCRMAvY8rJcNuwkHANtg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201260707150.21931@skynet.skynet.ie>
References: <alpine.DEB.2.00.1201251902590.12477@skynet.skynet.ie> <CA+55aFxTAHTXRmnK9AeJm525u28SGRxCRMAvY8rJcNuwkHANtg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > bunch of regression fixes since TTM rework and radeon initialisation,
> > modesetting fixes for Alex to fix some black screens on kms start type
> > issues, and two radeon ACPI fixes that make some laptops no oops on
> > startup.
> 
> Does that include for the nvidia (?) suspend/resume issue? You were
> cc'd on it (but the subject may have made you ignore it - it was part
> of a thread about wireless network suspend issues: "bcma/brcmsmac
> suspend/resume cleanups and fixes"):
> 

As Jerome said, Ben's ttm patch should fix it up. I meant to mention that.

Dave.
