Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2GXRrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:47:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2GXRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com>
Date: Wed, 25 Jul 2012 01:47:45 +0800
Message-ID: <CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Matthew

On Wed, Jul 25, 2012 at 1:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> Nothing in this patchset made me go "Eww", and several of them looked
> like good cleanups, but maybe somebody else hates this approach.

I remembered that Matthew objected caching firmware because he thought
it can't solve the isight camera problem after warm reset. But now,
this specific
problem can be solved easily by letting its driver defer probe.


Thanks,
--
Ming Lei
