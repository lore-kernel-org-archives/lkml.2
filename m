Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2GYM7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:59:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57797 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab2GYM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVN8Zwk09m8ryZ4G8+ya24PjOw=sfrjhH_jbUkg9REY+0w@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
	<CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
	<2841959.DtLAQqdt31@linux-lqwf.site>
	<CACVXFVN8Zwk09m8ryZ4G8+ya24PjOw=sfrjhH_jbUkg9REY+0w@mail.gmail.com>
Date: Wed, 25 Jul 2012 20:59:34 +0800
Message-ID: <CACVXFVO9o-p7ikBqGijJqBc_vbsE+dYMZnLiUz4ZS5C-amJ6LQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 8:50 PM, Ming Lei <ming.lei@canonical.com> wrote:
>      - no harm to thaw all user space tasks before thawing all kernel threads
>      (there isn't any dependency about the thawing order)

Sorry, I mean there isn't any constraint about the order, but the 'dependency'
may be just what the patch is introducing.


Thanks,
--
Ming Lei
