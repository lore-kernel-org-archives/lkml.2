Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab0HIIhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:37:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:40895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0HIIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:37:44 -0400
Subject: Re: [PATCH] Add quick erase format option
From: David Woodhouse <dwmw2@infradead.org>
To: "stefani@seibold.net" <stefani@seibold.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
In-Reply-To: <1281342353-18180-1-git-send-email-stefani@seibold.net>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 09:37:18 +0100
Message-ID: <1281343038.12908.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 09:25 +0100, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch add a quick format option which skips erasing of already erased
> flash blocks. This is useful for first time production environments where
> the flash arrived erased.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net> 

This scares me, given the lengths we had to go to in JFFS2 to cope with
blocks which *look* like they're erased, but which actually start losing
data as soon as you start writing to them because the erase didn't
complete.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


