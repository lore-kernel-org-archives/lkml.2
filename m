Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab1LODOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:14:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63962 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1LODOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:14:06 -0500
Date: Wed, 14 Dec 2011 19:14:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: slub: Lockout validation scans during freeing of object
In-Reply-To: <alpine.LFD.2.02.1112120917230.2555@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1112141913500.27595@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111230922210.16544@router.home> <alpine.LFD.2.02.1112120917230.2555@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Pekka Enberg wrote:

> > Subject: slub: Lockout validation scans during freeing of object
> > 
> > Slab validation can run right now while the slab free paths prepare
> > the redzone fields etc around the objects in preparation of the
> > actual freeing of the object. This can lead to false positives.
> > 
> > Take the node lock unconditionally during free so that the validation
> > can examine objects without them being disturbed by freeing operations.
> > 
> > Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>
