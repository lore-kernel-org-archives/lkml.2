Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1C1CrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:47:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569Ab1C1CrP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <27521.1300989784@redhat.com>
References: <27521.1300989784@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Mar 2011 19:46:23 -0700
Message-ID: <AANLkTiny-bKXdfnXsygeZ-RDqduYJNWMLXxcRT-cSy_g@mail.gmail.com>
Subject: Re: [GIT PULL] NOMMU and FRV patches
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, tglx@linutronix.de,
        amwang@redhat.com, vapier@gentoo.org, lethal@linux-sh.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:03 AM, David Howells <dhowells@redhat.com> wrote:
>
> Can you pull these patches please?

No.

Because they are sh*t that have clearly never been tested, and have
never been in -next.

They don't even compile on anything but NOMMU, as far as I can tell.
That new "vcoalesce()" helper is crap:

  drivers/base/firmware_class.c: In function ‘firmware_loading_store’:
  drivers/base/firmware_class.c:251:29: error: expected expression
before ‘...’ token
  drivers/base/firmware_class.c:251:29: error: too few arguments to
function ‘vmap’
  include/linux/vmalloc.h:70:14: note: declared here

please send it to me next merge-window, when it has actually sat in -next.

                Linus
