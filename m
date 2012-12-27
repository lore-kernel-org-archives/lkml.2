Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2L0KhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 05:37:15 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50596 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2L0KhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 05:37:13 -0500
X-Greylist: delayed 1559 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2012 05:37:12 EST
MIME-Version: 1.0
In-Reply-To: <1356573611-18590-15-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-15-git-send-email-koverstreet@google.com>
Date: Thu, 27 Dec 2012 11:37:11 +0100
Message-ID: <CAJAFBLD8z+X30U2LOWZ7TOjCYw+dFxgwwOuwPSHDO5Ebtpgv1A@mail.gmail.com>
Subject: Re: [PATCH 13/32] wait: Add wait_event_hrtimeout()
From: Fubo Chen <fubo.chen@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 2:59 AM, Kent Overstreet <koverstreet@google.com> wrote:
> Analagous to wait_event_timeout() and friends, this adds
> wait_event_hrtimeout() and wait_event_interruptible_hrtimeout().

That probably should have been "analogous" instead of "analagous" ?

Thanks,

Fubo.
