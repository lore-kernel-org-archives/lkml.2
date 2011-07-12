Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1GLUk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:40:29 -0400
Received: from mail.perches.com ([173.55.12.10]:3909 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab1GLUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:40:28 -0400
Subject: Re: [PATCH 2/2] MAINTAINERS: Add a maintainer for EFI
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1310502243-19306-2-git-send-email-mjg@redhat.com>
References: <1310502243-19306-1-git-send-email-mjg@redhat.com>
	 <1310502243-19306-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 13:40:26 -0700
Message-ID: <1310503226.6925.46.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 16:24 -0400, Matthew Garrett wrote:
> Since people other than ia64 are actually trying to use this now, it
> should probably be maintained. Sigh.
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> +EFI
> +M:	Matthew Garrett <mjg@redhat.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/firmware/efi/

Hi Matt.

Lucky you...

Please don't add an "L: lkml" entry.

It's the default.  No other entry but
the last one uses it.


