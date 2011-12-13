Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1LMWJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:09:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:41383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1LMWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:09:07 -0500
Date: Tue, 13 Dec 2011 22:09:03 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
cc: Jerome Glisse <j.glisse@gmail.com>, bskeggs@redhat.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] fixes to drm-next - TTM DMA code (v1)
In-Reply-To: <4EE77C02.1000103@vmware.com>
Message-ID: <alpine.LFD.2.02.1112132208310.24518@casper.infradead.org>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com> <20111213160753.GC2339@homer.localdomain> <4EE77C02.1000103@vmware.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi!
> 
> I'm not whether any drivers are still using the AGP backend?

Actually the openchrome projects KMS kernel uses a AGP backend.


> Calling unpopulate / (previous clear) each time unbind is done should be quite
> inefficient with that one, as AGP sets up its own data structures and copies
> page tables
> on each populate. That should really be avoided unless there is a good reason
> to have it.
> 
> /Thomas
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
