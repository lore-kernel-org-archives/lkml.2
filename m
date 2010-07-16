Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705Ab0GPG7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 02:59:36 -0400
Received: from kroah.org ([198.145.64.141]:36076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935668Ab0GPG7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 02:59:35 -0400
Date: Thu, 15 Jul 2010 23:59:01 -0700
From: Greg KH <greg@kroah.com>
To: William Pitcock <nenolod@dereferenced.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100716065901.GA31612@kroah.com>
References: <1278837584.2538.135.camel@edumazet-laptop> <11606525.291278863922663.JavaMail.root@ifrit.dereferenced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11606525.291278863922663.JavaMail.root@ifrit.dereferenced.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 07:58:42PM +0400, William Pitcock wrote:
> 2.6.32.16 (possibly 2.6.32.15) has a regression where it is unusable
> as a Xen domU.  I would say 2.6.32.12 is the best choice since who knows
> what other regressions there are in .16.

Did you happen to tell the stable maintainer about this and do a simple
'git bisect' to find the offending patch so that it can be resolved?

{sigh}

