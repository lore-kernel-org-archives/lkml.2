Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1CUFR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:17:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1CUFR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:17:26 -0400
Date: Mon, 21 Mar 2011 05:17:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] a couple of i_nlink fixes in btrfs
Message-ID: <20110321051725.GS22723@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
 <1299517070-sup-1687@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299517070-sup-1687@think>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:58:13AM -0500, Chris Mason wrote:

> Thanks, these both look good but I'll test here as well.  Are you
> planning on pushing for .38?

No, but .39 would be nice ;-)  Do you want that to go through btrfs tree
or through vfs one?
