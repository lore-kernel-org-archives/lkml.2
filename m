Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0LQTrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:47:33 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:46763 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751919Ab0LQTra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:47:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AO+TlRNi3ZtK57kA9Hjs49XIe/z0bqE26IIp/1CG646qj34fgkH/sfi6OnJ1QT0enQCwOmYhw5il8jRZKqsTu0GHauBAo0xlqgZrFfIzVz3ytsxrZmfzStvf5H5TtUUb;
Date: Fri, 17 Dec 2010 11:47:21 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jon Mason <jon.mason@exar.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ramkrishna Vepa <ramkrishna.vepa@exar.com>
Subject: Re: "x86: allocate space within a region top-down" causes bar0
 access issue
Message-ID: <20101217114721.04eafeca@jbarnes-desktop>
In-Reply-To: <20101217194457.GA4470@exar.com>
References: <20101217194457.GA4470@exar.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 13:44:58 -0600
Jon Mason <jon.mason@exar.com> wrote:

> The following patch is causing problem with the vxge driver/adapter on
> HP x86-64 systems. Reads to bar0 to return 0xffffffffffffffff instead
> of their intended value.  This prevents the vxge module from loading
> by failing sanity checks in the driver for certain values in bar0.  We
> are not seeing any issues with this patch on non-HP systems in our
> lab.
> 
> Can this patch be removed from 2.6.37 until a better solution can be
> found?

Can you try my for-linus branch and see if the problem still exists
there?  It's at
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
