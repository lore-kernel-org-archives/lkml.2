Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480Ab2FEOVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:21:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35719 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab2FEOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:21:40 -0400
Date: Tue, 5 Jun 2012 15:21:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Powerpc continued support?
Message-ID: <20120605142137.GB30000@ZenIV.linux.org.uk>
References: <4FCDA403.6070801@spin.net.au>
 <CA+5PVA4K51q=A9wA5kEHBzQ-01MrFZ5-uW3Qi4EvhVftk6acwA@mail.gmail.com>
 <4FCE0BFB.3010703@spin.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCE0BFB.3010703@spin.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 11:39:07PM +1000, Chris Jones wrote:
> >>Is it worth looking into this for a custom kernel?
> >Sure... whatever floats your boat I guess.
> 
> Something I might look into for custom kernel I suppose.

You do realize that ppc-only modules are not going to be built on
e.g. x86, don't you?  Not to mention the arch/powerpc stuff...
