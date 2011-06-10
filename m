Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1FJW6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:58:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60756 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab1FJW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:58:37 -0400
Date: Fri, 10 Jun 2011 23:58:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Why is CONFIG_FHANDLE an option??
Message-ID: <20110610225835.GC11521@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net>
 <20110610223955.GA11521@ZenIV.linux.org.uk>
 <20110610224738.GB11521@ZenIV.linux.org.uk>
 <alpine.LNX.2.00.1106110040370.21722@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106110040370.21722@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 12:42:50AM +0200, Jesper Juhl wrote:

> Yes, I'm aware of that. Doesn't mean we have to make things worse.
> Just because we've had optional syscalls in the past doesn't mean we have 
> to add more, nor that the existing ones were a good idea. IMHO they should 
> be removed as options and just included unconditionally - not too late to 
> correct this...

There's fanotify in that pile.  Consider that bright idea *strongly* NAKed.
