Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2DINiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:38:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51174 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab2DINiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:38:17 -0400
Date: Mon, 9 Apr 2012 14:37:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kay Sievers <kay@vrfy.org>
Cc: Theodore Tso <tytso@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120409133759.GH6589@ZenIV.linux.org.uk>
References: <4F80892A.7050104@zytor.com>
 <4F81D5C4.9000503@openvz.org>
 <20120408231841.42e28867@pyramind.ukuu.org.uk>
 <4F8210A5.7000900@zytor.com>
 <20120408234641.788f8426@pyramind.ukuu.org.uk>
 <4F821524.9090702@zytor.com>
 <4D2D856B-AE62-49D6-9ABE-5238E8B23A6C@mit.edu>
 <1333975435.29217.30.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333975435.29217.30.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 02:43:55PM +0200, Kay Sievers wrote:

> As mentioned earlier, udev is not involved at all here. It's all in the
> kernel these days; all device nodes are created by the kernel and not by
> udev.

... on the systems that have devtmpfs enabled.  And no, "runs castrated
udev" is not "all systems out there that might want a new kernel".
