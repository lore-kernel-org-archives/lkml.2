Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2HOOHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:07:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54074 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2HOOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:07:01 -0400
Date: Wed, 15 Aug 2012 07:06:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [ 36/44] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120815140655.GC22871@kroah.com>
References: <20120813220142.113186818@linuxfoundation.org>
 <20120813220145.337264645@linuxfoundation.org>
 <20120815002654.GA11666@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815002654.GA11666@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 09:26:54PM -0300, Henrique de Moraes Holschuh wrote:
> I believe the patch bellow, which was required on 3.2, will also be
> necessary.

Will it be necessary to apply this before this patch goes in the series,
or after it?

thanks,

greg k-h
