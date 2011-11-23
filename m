Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1KWW31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:29:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58279 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab1KWW30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:29:26 -0500
Date: Wed, 23 Nov 2011 14:29:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Kujau <lists@nerdbynature.de>, markus@trippelsdorf.de
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or
 corruption
In-Reply-To: <1322083191.1428.125.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1111231428440.5261@chino.kir.corp.google.com>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1111220855460.25785@router.home> <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1111231030370.14209@tux.localdomain>
 <alpine.DEB.2.00.1111230916220.16139@router.home> <1322083191.1428.125.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Pekka Enberg wrote:

> Yes, you did. I'm just trying to figure out which ones are going
> straight to Linus and which ones can wait for v3.3.
> 

I think it's 3.2-rc material since it can trigger a NULL pointer by 
reading a file from userspace, it's not limited only to debugging.
