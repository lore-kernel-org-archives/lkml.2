Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2LZRqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 12:46:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33871 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2LZRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 12:46:44 -0500
Date: Wed, 26 Dec 2012 09:50:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: "he, bo" <bo.he@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH V2] output the cpu number  when printking.
Message-ID: <20121226175004.GA23250@kroah.com>
References: <1356316276.2385.7.camel@hebo>
 <50D7CDED.4060308@infradead.org>
 <1356321255.2385.8.camel@hebo>
 <1356325315.2385.74.camel@hebo>
 <20121224175532.GA15041@kroah.com>
 <1356397745.2638.21.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1356397745.2638.21.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 09:09:05AM +0800, Yanmin Zhang wrote:
> On Mon, 2012-12-24 at 09:55 -0800, Greg KH wrote:
> > On Mon, Dec 24, 2012 at 01:01:55PM +0800, he, bo wrote:
> > > From: "he, bo" <bo.he@intel.com>
> > > 
> > > We often hit kernel panic issues on SMP machines because processes race
> > > on multiple cpu. By adding a new parameter printk.cpu, kernel prints
> > > cpu number at printk information line. It’s useful to debug what cpus
> > > are racing.
> > 
> > How useful is this really for normal developers?
> It's very useful to debug race conditions under SMP environment.
> We applied the patch to our Android build image on our smartphones.

That's fine for your application, and seemed to be useful to others
with their first interactions with SMP systems.  However, once you start
to get to "real" numbers of CPUs, this information turns pretty
pointless, which is why the patch was originally rejected.

sorry,

greg k-h
