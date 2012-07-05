Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2GETEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:04:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40226 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab2GETES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:04:18 -0400
Date: Thu, 5 Jul 2012 21:04:03 +0200 (CEST)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@debianer
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sunrpc/cache.h: replace simple_strtoul
In-Reply-To: <20120704235921.GA26797@fieldses.org>
Message-ID: <alpine.DEB.2.02.1207052030500.6309@debianer>
References: <1341442827-21339-1-git-send-email-eldad@fogrefinery.com> <1341442827-21339-2-git-send-email-eldad@fogrefinery.com> <20120704235921.GA26797@fieldses.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Jul 2012, J. Bruce Fields wrote:
> On Thu, Jul 05, 2012 at 01:00:26AM +0200, Eldad Zack wrote:
> > This patch replaces the usage of simple_strtoul with kstrtoint in
> > get_int().
> 
> Why?

Since the simple_str* family don't account for overflow and AFAIK
deprecated. Also, in this specific case, the long from strtol is 
silently converted to an int by the caller.

Eldad


