Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0LBVkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:40:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:7332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab0LBVkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:40:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,289,1288594800"; 
   d="scan'208";a="632548600"
Date: Thu, 2 Dec 2010 16:40:11 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
Message-ID: <20101202214011.GE5009@linux.intel.com>
References: <444316.89210.qm@web31808.mail.mud.yahoo.com>
 <20101201010715.GB9108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201010715.GB9108@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:07:15PM -0800, Greg KH wrote:
> On Thu, Oct 28, 2010 at 01:05:14PM -0700, Luben Tuikov wrote:
> > The reason to do this is to accommodate sending
> > different IU types using the existing
> > infrastructure.
> > 
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> Matthew, it's been over a month, please comment on these UAS patches, or
> I guess I'll just apply them...

Hi Greg,

These patches are NAKed in their current form.  Luben does not care for how
I have modified them, so I need to rework them to take his name off them.
I'll have a git tree ready for you after the weekend.
