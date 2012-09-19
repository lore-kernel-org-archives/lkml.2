Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2ISCsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:48:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53550 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2ISCsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:48:40 -0400
Date: Wed, 19 Sep 2012 03:48:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -next, RESEND] av32: Make sure _TIF_BREAKPOINT is defined
Message-ID: <20120919024838.GX13973@ZenIV.linux.org.uk>
References: <1347992361-11510-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347992361-11510-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:19:21PM +0200, Geert Uytterhoeven wrote:

> Still not fixed after almost 4 months...

Gyah...  I really need to trim that pile of internal branches; the fixed
commit had not been cherry-picked into for-next.  My apologies ;-/
