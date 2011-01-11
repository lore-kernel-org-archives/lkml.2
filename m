Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab1AKTDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:03:41 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:48258 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932399Ab1AKTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:03:39 -0500
Date: Tue, 11 Jan 2011 11:03:39 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Message-ID: <20110111190338.GA1542@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
 <201012221132.41057.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012221132.41057.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 05:02:40PM -0800, Rusty Russell wrote:
> On Thu, 16 Dec 2010 08:30:19 am Dmitry Torokhov wrote:
> > Currently only drivers that are built as modules have their versions
> > shown in /sys/module/<module_name>/version, but this information might
> > also be useful for built-in drivers as well. This especially important
> > for drivers that do not define any parameters - such drivers, if
> > built-in, are completely invisible from userspace.
> > 
> > This patch changes MODULE_VERSION() macro so that in case when we are
> > compiling built-in module, version information is stored in a separate
> > section. Kernel then uses this data to create 'version' sysfs attribute
> > in the same fashion it creates attributes for module parameters.
> >
 
...

> 
> __used and unused seems overkill, and confused.
> 
> Removed unused.
> 

Rusty,

What is the status of the patch? It woudl be nice if it coudl make it
into .38.

Thanks!

-- 
Dmitry

