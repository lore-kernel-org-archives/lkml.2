Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab1JFSe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:34:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52507 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758915Ab1JFSe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:34:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Bojan Smojver" <bojan@rexursive.com>
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Thu, 6 Oct 2011 20:37:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1317342456.1959.6.camel@shrek.rexursive.com> <201110050007.01025.rjw@sisk.pl> <3169978091.1002283638@rexursive.com>
In-Reply-To: <3169978091.1002283638@rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110062037.14322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 05, 2011, Bojan Smojver wrote:
> ------- Original message -------
> > From: Rafael J. Wysocki
> > Sent: 5.10.'11,  8:10
> 
> > Applied to linux-pm/linux-next.
> 
> Thank you.

I get a kernel panic on a test box using a x86_64 kernel with this patch
applied.

I'm going to drop it from my linux-next branch for now.

Thanks,
Rafael
