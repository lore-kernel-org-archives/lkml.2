Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2A0SUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:20:25 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36375
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab2A0SUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:20:24 -0500
Date: Fri, 27 Jan 2012 13:20:17 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] uml/hostfs: Propagate dirent.d_type to filldir()
Message-ID: <20120127182016.GA15705@infradead.org>
References: <y>
 <1327688098-10159-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327688098-10159-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 07:14:58PM +0100, Geert Uytterhoeven wrote:
> Currently the (optional) d_type member in struct dirent is always
> DT_UNKNOWN on hostfs, which may confuse buggy software using readdir().
> Make sure to propagate its value from the underlying filesystem if it's
> available there.

What software would that be?  We have lots of filesystems not filling
in d_type, and several operating systems don't have it at all.

