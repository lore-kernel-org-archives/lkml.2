Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1JJIZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:25:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33574 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1JJIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:25:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
References: <20111006190526.GA13883@redhat.com>
	<201110071640.53827.frank.mehnert@oracle.com>
	<CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
Date: Mon, 10 Oct 2011 09:25:29 +0100
Message-ID: <CAPM=9txVy7beVpK8bBo_K_GGckx+o7X7TL0y4ZWwJ5jq9GY2RA@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Dave Airlie <airlied@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frank Mehnert <frank.mehnert@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is holding you back from submitting the vbox modules to kernel
> staging tree and starting to clean it up for proper inclusion?

They enjoy the ability to change the userspace ABI at will and ship
everything in one place.

Dave.
