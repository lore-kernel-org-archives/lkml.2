Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1F1WSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:18:17 -0400
Received: from mail.perches.com ([173.55.12.10]:3283 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1F1WSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:18:08 -0400
Subject: Re: [PATCH 03/29] gma500: Ensure the frame buffer has a linear
 virtual mapping
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20110628230245.4cec6958@lxorguk.ukuu.org.uk>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
	 <20110616160642.6039.31781.stgit@localhost.localdomain>
	 <20110628211859.GA23217@kroah.com>
	 <20110628230245.4cec6958@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 15:18:06 -0700
Message-ID: <1309299486.29598.35.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 23:02 +0100, Alan Cox wrote:
> Really though this sort of treewide trivial has to stop, its costing tons
> of time and delays in real work. It should all be going via maintainers
> of subsystems but clearly Jiri is letting stuff through that isn't
> trivial but is in fact nuisance.

Because standardizing APIs is too hard?

Another option is for you to develop with -next.

