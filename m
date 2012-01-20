Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2ATOUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:20:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2ATOUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:20:05 -0500
Date: Fri, 20 Jan 2012 23:20:02 +0900 (JST)
Message-Id: <20120120.232002.849876084731555262.yamato@redhat.com>
To: kzak@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20120120140444.GC13157@x2.net.home>
References: <20120120140444.GC13157@x2.net.home>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>  I'd like to add support for /etc/fstab.d to libmount. The library is
>  currently used by mount, umount and mount.nfs. The goal is to use it
>  on more places.
> 
>  The /etc/fstab.d directory has been requested by people who maintains
>  large number of mountpoints etc.
> 
>  The directory is not replacement for /etc/fstab, it's additional place
>  where you can describe your filesystems.
> 
>  The disadvantage is that the stuff in the directory will be invisible
>  for some tools (udisks, systemd, ...), so I have very vocal
>  disagreement from some people who don't want to see /etc/fstab.d at all.

I'm working on systemd to support /etc/fstab.d.

Masatake YAMATO
