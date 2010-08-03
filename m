Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0HCIcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:32:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54334 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0HCIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AthP63HgrF8WOQQHCst68a2mInhiRnYfqoTW4Wh3BI92Xt+lemNwn0GlVLMjT5Yacc
         74Gn/BY5d6XOdfL+EzsXe3MUgnGwOnGXvcwpVrns+yGhXtz1B45u1zKicMKGVzT8Z+G0
         xhcTvYzmzs1y2bkDe4yW75PyhdYQRgJme2SNE=
Date: Tue, 3 Aug 2010 16:36:18 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: hacklu <embedway.linux@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how about KBUILD_MODNAME
Message-ID: <20100803083618.GE5129@cr0.nay.redhat.com>
References: <201008031037022524247@gmail.com>
 <201008031511572638256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008031511572638256@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 03:11:59PM +0800, hacklu wrote:
>
>I don't understand the macro KBUILD_MODNAME .
>when I compile a  driver program. It returns me "linux/pci.h:655: error: 'KBUILD_MODNAME' undeclared (first use in this function) "
>
>In the makefile I had used the "-D" options
>

You don't need to care about KBUILD_MODNAME, it is defined
internally by kbuild and passed to your module via "-DKBUILD_MODNAME=XXX"
automatically.

So, it looks like you didn't write your makefile correctly.
