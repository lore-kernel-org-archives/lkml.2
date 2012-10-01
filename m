Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2JAVwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:52:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49047 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2JAVwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:52:04 -0400
Date: Mon, 1 Oct 2012 23:52:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pierre Beck <mail@pierre-beck.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 32-bit PAE miscalculates dirty page limits
Message-ID: <20121001215202.GB19126@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Pierre Beck <mail@pierre-beck.de>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
References: <5068130A.4050602@pierre-beck.de>
 <506894D5.5060101@zytor.com>
 <506A06B6.50800@pierre-beck.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <506A06B6.50800@pierre-beck.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 11:10:47PM +0200, Pierre Beck wrote:
> But what about other folks who upgrade their PC? They won't know what
> hit them when their new PC crawls because disk is trashed.

I don't know, maybe backup their data, install a nice 64-bit Linux
distro of their liking along with a 64-bit kernel which is several
magnitudes more tested than its 32-bit counterpart, copy their data back
and forget 32-bit ever existed...

:-)

-- 
Regards/Gruss,
    Boris.
