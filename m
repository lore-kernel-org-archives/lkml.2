Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1AJSof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:44:35 -0500
Received: from kroah.org ([198.145.64.141]:37924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab1AJSoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:44:34 -0500
Date: Mon, 10 Jan 2011 10:44:16 -0800
From: Greg KH <greg@kroah.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/4] De-couple sysfs memory directories from memory
 sections
Message-ID: <20110110184416.GA18974@kroah.com>
References: <4D2B4B38.80102@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B4B38.80102@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 12:08:56PM -0600, Nathan Fontenot wrote:
> This is a re-send of the remaining patches that did not make it
> into the last kernel release for de-coupling sysfs memory
> directories from memory sections.  The first three patches of the
> previous set went in, and this is the remaining patches that
> need to be applied.

Well, it's a bit late right now, as we are merging stuff that is already
in our trees, and we are busy with that, so this is likely to be ignored
until after .38-rc1 is out.

So, care to resend this after .38-rc1 is out so people can pay attention
to it?


> The root of this issue is in sysfs directory creation. Every time
> a directory is created a string compare is done against all sibling
> directories to ensure we do not create duplicates.  The list of
> directory nodes in sysfs is kept as an unsorted list which results
> in this being an exponentially longer operation as the number of
> directories are created.

Are you sure this is still an issue?  I thought we solved this last
kernel or so with a simple patch?

thanks,

greg k-h
