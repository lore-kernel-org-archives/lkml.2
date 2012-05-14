Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2ENAcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 20:32:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:58735 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab2ENAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 20:32:20 -0400
Message-ID: <1336955527.6727.2.camel@pasglop>
Subject: Re: [PATCH v3 03/17] powerpc: Add PFO support to the VIO bus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Mon, 14 May 2012 10:32:07 +1000
In-Reply-To: <1336687098.3881.63.camel@pasglop>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
	 <1334243302.18090.10.camel@key-ThinkPad-W510>
	 <1335841603.3621.8.camel@pasglop>
	 <20120510190835.GB12304@linux.vnet.ibm.com>
	 <1336687098.3881.63.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 07:58 +1000, Benjamin Herrenschmidt wrote:
> > 
> > Having the timeout and retries in this function is the wrong thing to do.
> > We'll resubmit this without the loop and the caller will be responsible for
> > retrying the operations.
> >
> > I would rather have the caller cede the processor or alter thread
> > priority where appropriate than doing that in this function.  I don't
> > think this should be done in this crypto driver.
> 
> That sounds right indeed... as long as the upper crypto layer has a
> concept of "try again later"... if it doesn't it will result in random
> funny failures :-)

Ping ?

So I'm merging 1 to 5 (ie, up to and including the hwrng driver). I will
still merge the rest if you send a fix for that in the next day or so
but not much longer.

Cheers,
Ben.


