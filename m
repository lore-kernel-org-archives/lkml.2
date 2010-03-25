Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0CYIjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:39:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57777 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0CYIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GqDpy2j66Ecz5Sr0zzsZaXPXykPXUr8JPt9B47mauv0F3twmWD/8Str7ZxCesYjnhk
         pWy4CNkNSbYWCAbjfowAsJ+PcCJnEUGlC+W/zzYu9GfsBMCvsIfSHgNZDkubvyIdIflO
         HxzyZzEO/6813UVHjuwHMYXlrhnsd0CTyCLn0=
MIME-Version: 1.0
In-Reply-To: <1269417391.8599.188.camel@pasglop>
References: <1269417391.8599.188.camel@pasglop>
Date: Thu, 25 Mar 2010 14:09:49 +0530
Message-ID: <62fe9ccc1003250139m7e8fecf9g2976a1bc244f6aa5@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmalloc: Export purge_vmap_area_lazy()
From: MJ embd <mj.embd@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 1:26 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Some powerpc code needs to ensure that all previous iounmap/vunmap has
> really been flushed out of the MMU hash table. Without that, various
> hotplug operations may fail when trying to return those pieces to
> the hypervisor due to existing active mappings.
Are you talking about KVM or any other hypervisor ?
