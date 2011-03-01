Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1CARhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:37:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:62667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1CARhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,248,1297065600"; 
   d="scan'208";a="607845705"
Subject: Re: [PATCH 04/10] PTI Makefile and Kconfig additions.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <201103011237.50400.arnd@arndb.de>
References: <james_p_freyensee@linux.intel.com>
	 <201102281031.42402.arnd@arndb.de> <1298915373.3156.34.camel@localhost>
	 <201103011237.50400.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 01 Mar 2011 09:37:45 -0800
Message-ID: <1299001065.3156.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 12:37 +0100, Arnd Bergmann wrote:
> On Monday 28 February 2011, J Freyensee wrote:
> > On Mon, 2011-02-28 at 10:31 +0100, Arnd Bergmann wrote:
> >
> > > The Kconfig description is a nice text, how about copying it to the
> > > changeset so that reviewers know what the driver is about?
> > > 
> > 
> > I thought patch 02/10, 'Kernel documentation', would had been first and
> > met this need?  
> 
> Documentation in source files is not the same as documentation in the
> changelog, you need both. The changeset comments are usually just one
> sentence in your series, and a little more would certainly be helpful.
> 

Okay, I can do that.

Thanks,
Jay

> Also, if you have one changeset with the documentation, that does
> not help anyone who looks at another changeset.
> 
> 	Arnd


