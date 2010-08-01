Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0HAMlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 08:41:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54841 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0HAMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 08:41:12 -0400
Date: Sun, 1 Aug 2010 14:40:59 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
Message-ID: <20100801124059.GA7977@pengutronix.de>
References: <20100730142519.18287.22053.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100730142519.18287.22053.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 30, 2010 at 03:25:19PM +0100, David Howells wrote:
> Remove the __exit mark from cifs_exit_dns_resolver() as it's called by the
> module init routine in case of error, and so may have been discarded during
> linkage.
>From time to time I think about introducing something like
__init_or_exit that puts a function into .init.text if .exit.text is
discarded.  Is it worth the effort?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
