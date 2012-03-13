Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab2CMR7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:59:47 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:21128 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab2CMR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:59:46 -0400
Message-ID: <4F5F8B10.1090209@tilera.com>
Date: Tue, 13 Mar 2012 13:59:44 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <arnd@arndb.de>
Subject: Re: [PATCH 29/35] Disintegrate asm/system.h for Tile [ver #2]
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312234058.13888.826.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312234058.13888.826.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 7:40 PM, David Howells wrote:
> Disintegrate asm/system.h for Tile.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Chris Metcalf <cmetcalf@tilera.com>

This looks like you compile-tested it, at least, and looks about right.  If
further changes seem useful I'm happy to propose them after this hits
main.  So:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

