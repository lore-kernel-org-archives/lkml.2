Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2D2QFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:05:42 -0400
Received: from imr4.ericy.com ([198.24.6.9]:50388 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2D2QFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:05:41 -0400
Date: Sun, 29 Apr 2012 09:04:00 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jens Gustedt <jens.gustedt@loria.fr>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG in 3.3.4
Message-ID: <20120429160400.GA29231@ericsson.com>
References: <iTWyS-35l-7@gated-at.bofh.it>
 <4F9D2A2B.9090501@loria.fr>
 <20120429155524.GA29152@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120429155524.GA29152@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to include the list.

On Sun, Apr 29, 2012 at 08:55:24AM -0700, Guenter Roeck wrote:
> On Sun, Apr 29, 2012 at 01:46:51PM +0200, Jens Gustedt wrote:
> > Hi,
> > it looks that there is a regression in 3.3.4 compared to 3.3.3.
> > 
> > After migrating I have the BUG as copied below.
> > 
> > If somebody thinks that this would make sense, I could try to bisect this.
> > 
> Introduced by upstream commit 2a748853ca395c48ea75baa250f7cea6f0f23dbf,
> fixed upstream with d62d421b071b08249361044d8e56c8b5c3ed6aa7.
> 
> I sent a request to stable a minute ago.
> 
> Guenter
