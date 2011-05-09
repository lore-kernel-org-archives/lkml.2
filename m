Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1EIQn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:43:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1EIQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:43:27 -0400
Date: Mon, 9 May 2011 12:38:45 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/38] 2.6.38.6-stable review
Message-ID: <20110509123845.62039af9@katamari>
In-Reply-To: <20110506001225.GA10547@kroah.com>
References: <20110506001225.GA10547@kroah.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011 17:12:25 -0700
Greg KH <gregkh@suse.de> wrote:

> 
> This is the start of the stable review cycle for the 2.6.38.6 release.
> There are 38 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by Sunday, May 8, 2011, 00:01:00 UTC.
> Anything received after that time might be too late.
> 

If it's not too late, can you add this one? It fixes a bug introduced in
2.6.38.4 by upstream commit 95042f9eb78a8d9a17455e2ef263f2f310ecef15:

commit: a1fde08c74e90accd62d4cfdbf580d2ede938fe7
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 21:30:28 -0700
Subject: [PATCH] VM: skip the stack guard page lookup in get_user_pages only
 for mlock

