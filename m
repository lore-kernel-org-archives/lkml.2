Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0HAGZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0HAGZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:25:07 -0400
Date: Sun, 1 Aug 2010 02:19:19 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [000/165] 2.6.32.17-rc1 -stable review
Message-ID: <20100801021919.1e8c2adb@katamari>
In-Reply-To: <20100730171550.GA1299@kroah.com>
References: <20100730171550.GA1299@kroah.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 10:15:50 -0700
Greg KH <gregkh@suse.de> wrote:

> 
> This is the start of the stable review cycle for the 2.6.32.17 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by August 1, 2010, 18:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.17-rc1.gz
> and the diffstat can be found below.
> 

I still don't see this one in 2.6.32-stable:

commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72 upstream.
Subject: ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files

This fixes CVE-2010-2066; I'm pretty sure 2.6.32 is vulnerable.
