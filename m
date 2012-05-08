Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2EHRAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:00:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49608 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695Ab2EHRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:00:44 -0400
X-Sasl-enc: 6kTnD4anKBIMCkhp05S5v0IukNTWS0SDSgfSDVff8IKv 1336496443
Date: Tue, 8 May 2012 10:00:42 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH RESEND 2/3] kmsg: export printk records to the /dev/kmsg
 interface
Message-ID: <20120508170042.GB19174@kroah.com>
References: <1336004981.4240.10.camel@mop>
 <20120508002830.GA2204@kroah.com>
 <1336495850.1179.41.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336495850.1179.41.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 06:50:50PM +0200, Kay Sievers wrote:
> On Tue, May 8, 2012 at 2:28 AM, Greg Kroah-Hartmann <greg@kroah.com> wrote:
> 
> > Can you add a file somwhere in Documentation (Documentatin/ABI?) that
> > documents the file format for this file?
> 
> Something like that? Please let me know, what else might be useful here.

This looks good to me, thanks.

greg k-h
