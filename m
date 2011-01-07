Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1AGVXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:23:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441Ab1AGVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:23:51 -0500
MIME-Version: 1.0
In-Reply-To: <20110106235016.GA2212@kroah.com>
References: <20110106235016.GA2212@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Jan 2011 13:22:40 -0800
Message-ID: <AANLkTi=rwv2CW-x_p9SrKghcPKD4TeOAP=2mtp8EcS34@mail.gmail.com>
Subject: Re: [GIT PATCH] USB merge for .38
To: Greg KH <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, Anand Gadiyar <gadiyar@ti.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 3:50 PM, Greg KH <gregkh@suse.de> wrote:
>
> Nothing radical here at all, lots of musb changes, which touched a bunch
> of arch-specific code, and some new drivers, mostly gadget ones.

There were also a number of conflicts with the ARM updates (omap clock
data in particular - added aliases, changed names, you name it).

I spent some time trying to fix it up properly, and maybe I even
succeeded, but you guys should really look the result over.

                       Linus
