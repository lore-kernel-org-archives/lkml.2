Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461Ab2DKXNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:13:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54061 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176Ab2DKXNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLroi_uGBUmwEE2g=nH2z-oD6nYwo_D+o+QHMtWERP=yvA@mail.gmail.com>
References: <1333479610-13321-1-git-send-email-paul.gortmaker@windriver.com>
	<CAP=VYLroi_uGBUmwEE2g=nH2z-oD6nYwo_D+o+QHMtWERP=yvA@mail.gmail.com>
Date: Wed, 11 Apr 2012 16:13:10 -0700
X-Google-Sender-Auth: 5emWCA2c-B8i8qJOC322PERU34k
Message-ID: <CA+8MBbJ-Ub9JtJ+nbMScOfcP6HtAjmQ0qZkWOa6H_3A3VHwz7g@mail.gmail.com>
Subject: Re: [PATCH] ia64: populate the cmpxchg header with appropriate code
From: Tony Luck <tony.luck@intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 3:35 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> Just wondering if you had a chance to look at this, and
> whether it was OK and in your queue.

My only concern is whether there are users who just include <asm/intrinsics.h>
to get xchg/cmpxchg ... but I guess it should be easy enough for anyone who
has breakage in this area to add <asm/cmpxchg.h>

> It has been in linux-next for > 1wk.

Sadly there are few testers for ia64 building linux-next ... so this doesn't
mean as much as it does for an x86 patch :-(

> I've got a fix for
> arch/alpha and I can bundle this along with it in a pull
> request if you don't have it in your queue already.

I don't have it queued. If you want to handle it, that is fine. Add an

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony
