Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab2JaRtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:49:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60323 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382Ab2JaRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:49:50 -0400
Date: Wed, 31 Oct 2012 10:49:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Cc: skinsbursky@parallels.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, baggins@pld-linux.org,
        arekm@pld-linux.org
Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
Message-ID: <20121031174946.GA13591@kroah.com>
References: <1689813.hptKgzjpAu@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1689813.hptKgzjpAu@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 06:27:36PM +0100, Paweł Sikora wrote:
> Hi,
> 
> the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to fix
> the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
> please queue this path for 3.6.$next.

Is it in Linus's tree already?  If so, what is the git commit id?

thanks,

greg k-h
