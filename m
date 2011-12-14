Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1LNS53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:57:29 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:64980 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1LNS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:57:28 -0500
Date: Wed, 14 Dec 2011 13:54:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <waldi@debian.org>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] xen: Add privcmd device driver
Message-ID: <20111214185436.GA24598@phenom.dumpdata.com>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
 <1323541791-18006-2-git-send-email-waldi@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323541791-18006-2-git-send-email-waldi@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4EE8F177.00F0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 07:29:46PM +0100, Bastian Blank wrote:
> Access to arbitrary hypercalls is currently provided via xenfs. This
> adds a standard character device to handle this. The support in xenfs
> remains for backward compatibility and uses the device driver code.

Bastian Blank (5):
      xen: Add privcmd device driver
      xen: Add xenbus device driver
      xen: Add xenbus_backend device
      xen/privcmd: Remove unused support for arch specific privcmp mmap
      xen/xenbus-frontend: Make error message more clear

Will wait for the re-worked sixth patch from you.
