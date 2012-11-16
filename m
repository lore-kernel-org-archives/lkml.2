Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab2KPHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:09:57 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37415 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730Ab2KPHJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:09:56 -0500
Message-ID: <1353049795.24310.35.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: extend line continuation test
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>, Andy Whitcroft <apw@canonical.com>,
        peter@hurleysoftware.com, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2012 23:09:55 -0800
In-Reply-To: <CAMuHMdVxZqQLK4cKD7oYj31c-=LoBsaaoTQTqJcHg-nzg2iG_w@mail.gmail.com>
References: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
	 <1353046873.24310.30.camel@joe-AO722>
	 <CAMuHMdVxZqQLK4cKD7oYj31c-=LoBsaaoTQTqJcHg-nzg2iG_w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 08:02 +0100, Geert Uytterhoeven wrote:
> On Fri, Nov 16, 2012 at 7:21 AM, Joe Perches <joe@perches.com> wrote:
> > Preprocessor directives and asm statements should be
> > allowed to have a line continuation.
> 
> For preprocessor directives I agree.
> 
> But why do asm statements need it? They'r just strings, so just closing with
> a double quote at the end of the first line, and opening again with a
> double quote
> on the next line works fine.

I agree it does, but it's a pretty common existing style and
I want to avoid people submitting unnecessary "fix" patches.


