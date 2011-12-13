Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1LMSek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:34:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49624 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1LMSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:34:38 -0500
Date: Tue, 13 Dec 2011 13:32:08 -0500 (EST)
Message-Id: <20111213.133208.1867222061450505776.davem@davemloft.net>
To: dhowells@redhat.com
Cc: sfr@canb.auug.org.au, torvalds@linux-foundation.org, arnd@arndb.de,
        alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 02/17] UAPI: Don't include linux/compat.h in sparc's
 asm/siginfo.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323770653-19177-3-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
	<1323770653-19177-3-git-send-email-dhowells@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 13 Dec 2011 10:32:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 13 Dec 2011 10:03:58 +0000

> Don't include linux/compat.h in sparc's asm/siginfo.h as it leads to a circular
> dependency:
> 
> 	asm/siginfo.h -> linux/compat.h -> asm/siginfo.h
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
