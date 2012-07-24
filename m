Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2GXRzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:55:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51204 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2GXRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com>
 <CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com> <CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 10:54:47 -0700
X-Google-Sender-Auth: sp4_ALSNpI2xyLMUEVPYO5n1Rys
Message-ID: <CA+55aFxeNNTacdhmBfy2Q3bitM92WNS2Gafv+D4eVRBb8nqKmA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 10:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The fact that USB confuses resuming existing devices and probing new
> ones is just an implementation issue, and is a bug.

Btw, I understand *why* it confuses the two. That doesn't make is less
of a bug, though.

                Linus
