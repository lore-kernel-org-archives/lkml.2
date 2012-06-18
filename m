Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2FRQjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:39:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59129 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961Ab2FRQjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:39:11 -0400
Message-ID: <1340037550.2182.27.camel@joe2Laptop>
Subject: Re: [PATCH 3/5] usb: Convert dbg to pr_eliminated and pr_debug
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Jun 2012 09:39:10 -0700
In-Reply-To: <20120618161445.GA17155@kroah.com>
References: <cover.1339985626.git.joe@perches.com>
	 <25071de4def201f947780d6937b9732ccac3b3f0.1339985627.git.joe@perches.com>
	 <20120618152315.GB1050@kroah.com> <1340035630.2182.19.camel@joe2Laptop>
	 <20120618161445.GA17155@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 09:14 -0700, Greg Kroah-Hartman wrote:
> On Mon, Jun 18, 2012 at 09:07:10AM -0700, Joe Perches wrote:
> > On Mon, 2012-06-18 at 08:23 -0700, Greg Kroah-Hartman wrote:
[]
> > > No, I really want to delete this macro entirely, and am slowly working
> > > toward that, moving drivers to use the correct dev_dbg() macro instead.
[]
> > And anyway, why go slowly?  Why not just do it?
> 
> I take it you didn't see the 200+ patches in 3.5-rc1 that did a lot of
> this work already?  Is that slow?

You said slowly.

I don't care much one way or another but
scripts work pretty quickly, humans less so.

dbg is certainly an ugly little wart though.


