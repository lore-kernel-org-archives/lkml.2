Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0DUUVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:21:41 -0400
Received: from tservice.ru ([195.178.208.66]:40122 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0DUUVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:21:40 -0400
Date: Thu, 22 Apr 2010 00:21:34 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421202134.GB25130@ioremap.net>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org> <20100421185657.GA21249@ioremap.net> <20100421200243.GU27575@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421200243.GU27575@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 09:02:43PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> FIEMAP might not be the answer, but what part of it requires fs
> knowledge?  It's supposed to be fs-independent.  I agree it's not
> always appropriate to use, and I don't know if it would be effective
> anyway.

At least we have to know whether given fs supports such interface.
And more complex is to know how underlying fs is organized. What is
extent, which types can it have, where exactly information about extent
metadata is stored, i.e. where can we find what this object is about?
And how to actually populate appropriate blocks into ram to speedup readdir()?

FIEMAP (which is file mapper btw :) is useful for information gathering
about how fs is organized, but that's all I'm afraid.

-- 
	Evgeniy Polyakov
