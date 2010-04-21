Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0DUUCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:02:48 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45894 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab0DUUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:02:45 -0400
Date: Wed, 21 Apr 2010 21:02:43 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421200243.GU27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org> <20100421185657.GA21249@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421185657.GA21249@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> > But if it does, go on, try FIEMAP and blockdev reading, you know you
> > want to :-)
> 
> Well, it requires substantial underlying fs knowledge and is not simple
> and, well, appropriate to do in some cases.

FIEMAP might not be the answer, but what part of it requires fs
knowledge?  It's supposed to be fs-independent.  I agree it's not
always appropriate to use, and I don't know if it would be effective
anyway.

-- Jamie
