Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2DCQUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:20:38 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46556 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2DCQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:20:37 -0400
MIME-Version: 1.0
In-Reply-To: <1333469800.26079.35.camel@joe2Laptop>
References: <1333415903.860.0.camel@mop> <1333420612.26079.6.camel@joe2Laptop>
 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
 <1333424865.26079.9.camel@joe2Laptop> <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
 <1333463572.26079.31.camel@joe2Laptop> <CAPXgP133MQX2u3H6imOR4FFR4TsHYc=f_yrAJfdd2sG-8bFrmA@mail.gmail.com>
 <1333469136.26079.33.camel@joe2Laptop> <CAPXgP11MBdqc3BiDLA1q5gW4BZy2q4PoLtD20oRXfKY+C-HOgw@mail.gmail.com>
 <1333469800.26079.35.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Apr 2012 18:20:16 +0200
Message-ID: <CAPXgP13--R6M3FAJ8QCB50eVTo7M9A30OW3rwwV3gv1QEtpBaQ@mail.gmail.com>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 18:16, Joe Perches <joe@perches.com> wrote:
> Conversations happen all over the place and making
> separate discussions isn't that valuable nor are
> they really controllable.

Sure, but this is not a conversation in that sense, you reply to a
patch that something is not correct, but what's not correct is not a
subject of the patch. And that I need to correct.

> Just write the change log to simply state "add KERN_CONT"
> without mentioning your unpublished stuff.

The changelog says:

"A prototype for kmsg records instead of a byte-stream buffer revealed
a couple of missing printk(KERN_CONT ...) uses. Subsequent calls produce
one record per printk() call, while all should have ended up in a single
record."

What else do you need?

Kay
