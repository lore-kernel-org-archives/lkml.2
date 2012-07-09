Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2GITmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:42:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61819 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2GITmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:42:15 -0400
Date: Mon, 9 Jul 2012 12:42:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH 1/4] staging:rts_pstor: Fix coding style issue in ms.c
Message-ID: <20120709194211.GA17980@kroah.com>
References: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 10:15:48AM +0900, Hitoshi Nakamori wrote:
> This is a patch to the ms.c that fixes up some brace warning found by checkpatch.pl tool.

Please wrap your comments at 72 columns.

As much as I endorce splitting patches up into tiny pieces, this is a
bit overkill, as you now have 4 patches with the same identical subject:

That implies that all of these could just be one patch, right?  Please
do that.

thanks,

greg k-h
