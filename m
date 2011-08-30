Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1H3STw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:19:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33287 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898Ab1H3STv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:19:51 -0400
X-Sasl-enc: bPegi+nj4UoaV8nz3WgA+gWGb42ubNlXnb5BmK8nGtxn 1314728390
Date: Tue, 30 Aug 2011 11:16:39 -0700
From: Greg KH <greg@kroah.com>
To: Vishnupradeep <intermedia.vishnu@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] linux-3.0.4 compile error on file
 arch/x86/include/asm/unistd_64.h
Message-ID: <20110830181639.GB24865@kroah.com>
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
 <4E5C8EA3.7060304@gmail.com>
 <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 11:37:33PM +0530, Vishnupradeep wrote:
> Yes, i am sure. I just downloaded from kernel.org and ran "make"

That's not how to properly configure and build a kernel.  Have you read
the documentation on how to do this?  Can you attach your .config file
that you used and ran into this error?

thanks,

greg k-h
