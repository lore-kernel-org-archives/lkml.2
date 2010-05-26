Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab0EZLia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:38:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52903 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289Ab0EZLi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:38:28 -0400
Date: Wed, 26 May 2010 05:38:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI quirk: AMD 780: work around wrong vendor ID on APC
	bridge
Message-ID: <20100526113826.GS10452@parisc-linux.org>
References: <4BFCF616.6060608@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFCF616.6060608@ladisch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:21:10PM +0200, Clemens Ladisch wrote:
> Since we do not know in advance all possible vendor IDs, a better way to
> find the device is to declare the quirk on the host bridge, whose ID is
> always correct, and use that device as a stepping stone to find the PCI/
> PCI bridge, if present.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Good idea.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
