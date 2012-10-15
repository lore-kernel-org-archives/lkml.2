Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2JPAAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:00:43 -0400
Received: from oker.escape.de ([194.120.234.254]:54967 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab2JPAAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:00:42 -0400
X-Greylist: delayed 888 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2012 20:00:42 EDT
Date: Tue, 16 Oct 2012 01:40:06 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: Juliusz Chroboczek <jch@pps.jussieu.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Write is not atomic?
Message-ID: <20121015234006.GK2842@pompeji.miese-zwerge.org>
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

On Mon, Oct 15, 2012 at 11:36:15PM +0200, Juliusz Chroboczek wrote:
> The Linux manual page for write(2) says:
> 
>     The adjustment of the file offset and the write operation are
>     performed as an atomic step.

This seems out of context.

Over here write(2) reads:

      If the file was open(2)ed with O_APPEND, the file offset is first
      set to the end of the file before writing.  The adjustment of the
      file offset and the write operation are performed as an atomic
      step.

Sounds different, doesn't it?


Hth,
Jochen.
