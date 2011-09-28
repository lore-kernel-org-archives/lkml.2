Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1I1NCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:02:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <1317196456.1998.24.camel@shrek.rexursive.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	<CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
	<1317194947.1998.18.camel@shrek.rexursive.com>
	<CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
	<1317196456.1998.24.camel@shrek.rexursive.com>
Date: Wed, 28 Sep 2011 16:02:34 +0300
X-Google-Sender-Auth: Xz0YQMqGa5FvJ_03OC8RoP3ZRxw
Message-ID: <CAOJsxLGUmV=5+fOJShbfc+kELcPS9pnE+DkNY9+TBS33VmzRFg@mail.gmail.com>
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:54 AM, Bojan Smojver <bojan@rexursive.com> wrote:
> I'm guessing here that you mean that parts of the kernel other than
> hibernation code itself can do this (i.e. set the flag for the thread to
> stop, so kthread_should_stop() returns true). Correct?

Sorry, I'm not familiar this code. However, if you're checking for the
condition..

[snip]

> Right now, this would result in - well I don't know what exactly - most
> likely corrupted data on disk or on memory.

...this is not really an option for handling it.

                         Pekka
