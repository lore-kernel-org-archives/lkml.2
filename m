Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1JJQtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:49:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1JJQtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGzyDut=6B-Xc0jBWFPNdTzG8vzoVJdyLfBbjyRDx-eWw@mail.gmail.com>
References: <20111006190526.GA13883@redhat.com>
	<201110071640.53827.frank.mehnert@oracle.com>
	<CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
	<20111010142418.GC21944@kroah.com>
	<CAOJsxLGzyDut=6B-Xc0jBWFPNdTzG8vzoVJdyLfBbjyRDx-eWw@mail.gmail.com>
Date: Mon, 10 Oct 2011 17:49:05 +0100
Message-ID: <CAPM=9tye+m_MV32x-Qmoj+2ie5Q0MjVzsKtuOsfgNQvK3zn9TQ@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Dave Airlie <airlied@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>, Frank Mehnert <frank.mehnert@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I actually have and had a rough patch that added the code to staging
> directory in the kernel tree.
>
> Admittedly I don't remember anything about the code but surely it
> meets the standards of what we already have there? :-)

unless upstream commits to some sort of stable ABI policy there is no
point, you'd just have to ship a module that somehow magically exposes
different probably incompatible interfaces depending on what userspace
was running on it.

Dave.
