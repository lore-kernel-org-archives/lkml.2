Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0LHQfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:35:18 -0500
Received: from ist.d-labs.de ([213.239.218.44]:56403 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0LHQfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:35:17 -0500
Date: Wed, 8 Dec 2010 17:34:24 +0100
From: Florian Mickler <florian@mickler.org>
To: Keith Packard <keithp@keithp.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm: record monitor status in
 output_poll_execute
Message-ID: <20101208173424.76ec4041@schatten.dmk.lab>
In-Reply-To: <yunpqtgexml.fsf@aiko.keithp.com>
References: <1290797159-3977-1-git-send-email-keithp@keithp.com>
	<1290797159-3977-2-git-send-email-keithp@keithp.com>
	<20101205132743.3b3458ab@schatten.dmk.lab>
	<yunpqtgexml.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Dec 2010 13:08:18 -0800
Keith Packard <keithp@keithp.com> wrote:

> On Sun, 5 Dec 2010 13:27:43 +0100, Florian Mickler <florian@mickler.org> wrote:
> > On Fri, 26 Nov 2010 10:45:59 -0800
> > Keith Packard <keithp@keithp.com> wrote:
> > 
> > > In order to correctly report monitor connected status changes, the
> > > previous monitor status must be recorded in the connector->status
> > > value instead of being discarded.
> > > 
> > > Signed-off-by: Keith Packard <keithp@keithp.com>
> > 
> > Keith, am I right to assume that these address 
> > https://bugzilla.kernel.org/show_bug.cgi?id=22672
> > and probably:
> > https://bugzilla.kernel.org/show_bug.cgi?id=23472
> 
> Yes, this is part of the patch for that. The other piece is in the 2D
> driver which has a matching bug. That patch is already on master.
> 

Does that mean that the kernel regression will not be
fixed/worked-around for old userspace? 

Regards,
Flo
