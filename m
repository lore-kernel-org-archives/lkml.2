Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0JJXw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 19:52:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58931 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0JJXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 19:52:57 -0400
Date: Mon, 11 Oct 2010 00:52:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
Message-ID: <20101010235256.GG19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
 <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
 <20101010144952.GF19804@ZenIV.linux.org.uk>
 <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 10:18:03PM +0200, Geert Uytterhoeven wrote:
> >> This is on aranym-0.9.9-1 from Ubuntu/amd64.
> >
> > stat -L /proc/2/exec, otherwise you'll hit lstat() instead of stat().
> > And FWIW 0.9.10-1 squeeze/amd64 also triggers here...
> 
> Still, just "stat: cannot stat `proc/2/exe': No such file or directory" here...

Interesting...  Which gcc version is used?
