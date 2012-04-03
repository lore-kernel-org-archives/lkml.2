Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2DCDrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 23:47:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60343 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751548Ab2DCDrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 23:47:47 -0400
Message-ID: <1333424865.26079.9.camel@joe2Laptop>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Mon, 02 Apr 2012 20:47:45 -0700
In-Reply-To: <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
References: <1333415903.860.0.camel@mop>
	 <1333420612.26079.6.camel@joe2Laptop>
	 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 05:00 +0200, Kay Sievers wrote:
> On Tue, Apr 3, 2012 at 04:36, Joe Perches <joe@perches.com> wrote:
> > A couple of other trivial comments:
> > It's better to try to coalesce multiple printks(KERN_CONT
> > (perhaps it's better to use pr_cont instead too)
> > Branches with the same printks should be hoisted where
> > possible.
> Sure, please send patches for anything that is more appropriate to use here.
> I did not want to change any logic which needs to be tested. I just
> trivially added the obviously missing prefix, which solved the
> problem, and which could be applied right away.

I think you should do it "right" rather than add
trivial markers.


