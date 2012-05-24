Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2EXAkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:40:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2EXAkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:40:40 -0400
Date: Wed, 23 May 2012 17:40:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sameer Rahmani <lxsameer@lxsameer.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Slab vs Slub vs slob vs slqb
In-Reply-To: <4FBD1A2C.7020303@lxsameer.com>
Message-ID: <alpine.DEB.2.00.1205231738420.8785@chino.kir.corp.google.com>
References: <4FBD1A2C.7020303@lxsameer.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Sameer Rahmani wrote:

> Hi,
> Simple question from a newbie, i know what is SLAB is, but what is slub and
> slob or slqb ?
> what is there different ?

SLUB, SLOB, and SLQB are all different varients of slab allocators and can 
be chosen as a replacement for SLAB.  SLUB gets the most attention these 
days and is the upstream default.  SLOB is typically used for embedded 
devices and those that require a small memory footprint.  SLQB was a 
development allocator that I believe has been abandoned.
