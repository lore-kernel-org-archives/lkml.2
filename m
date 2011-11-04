Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1KDNOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:14:39 -0400
Received: from 8bytes.org ([88.198.83.132]:59073 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1KDNOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:14:38 -0400
Date: Fri, 4 Nov 2011 14:14:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
Message-ID: <20111104131436.GN1512@8bytes.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain> <20111104121601.GA15206@infradead.org> <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:35:18PM +0200, Pekka Enberg wrote:
> We are reusing kernel code and headers and I am not interested in
> copying them over. Living in the kernel tree is part of the design,
> whether you like it or not.

Besides that the KVM tool with its small and clean code-base is a really
nice reference on how to use the KVM kernel interface for anyone willing
to implement its own user-space. As a developer you can learn a lot more
from it as by reading the files on Documentation/.  So I think it should
definitly be part of the kernel source tree.

Whether it lives in tools/ or Documentation/ ... I don't care. In tools/
is certainly better for all the developers already using the it for
testing their kernels.

Regards,

	Joerg

