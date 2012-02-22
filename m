Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2BVVbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:31:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2BVVbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:31:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 13:30:55 -0800
X-Google-Sender-Auth: VFdJdNrB6US5gXLWAknq22f_aUA
Message-ID: <CA+55aFwR52ny2P6p5qkqQwEU3NFV8+EJNtfGx=9j8Gzr_LtD6Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 1:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The good news is that I *think* the whole i387 handling code hasn't
> been touched much. But I didn't really check deeply.

Btw, the backport was done to 3.2.0, in case you wonder. So that's
what the patches apply to. Whether they work, and whether they apply
to anything else, I'll leave for others to check ;)

            Linus
