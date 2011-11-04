Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1KDMQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:16:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33820
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1KDMQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:16:32 -0400
Date: Fri, 4 Nov 2011 08:16:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
Message-ID: <20111104121601.GA15206@infradead.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 10:38:21AM +0200, Pekka Enberg wrote:
> Hi Linus,
> 
> Please consider pulling the latest KVM tool tree from:

There still is absolutely zero reason to throw it in the kernel tree.

Please prepare a nice standalone git repository and tarball for it.

