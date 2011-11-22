Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab1KVVvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:51:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52735 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab1KVVvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:51:52 -0500
Date: Tue, 22 Nov 2011 13:51:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC, PATCH] slub: unfreeze_partials() uses a wrong param
In-Reply-To: <alpine.DEB.2.00.1111220948240.25785@router.home>
Message-ID: <alpine.DEB.2.00.1111221351030.2621@chino.kir.corp.google.com>
References: <1321976189.2474.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1111220948240.25785@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Christoph Lameter wrote:

> > unfreeze_partials() calls add_partial(..., 1) while it should use
> > DEACTIVATE_TO_TAIL or DEACTIVATE_TO_HEAD
> 
> Something like that must already be pending in Pekka's tree. I have seen
> this patch a couple of times before.

Yeah, it's "slub: use correct parameter to add a page to partial list 
tail" in slab/urgent.
