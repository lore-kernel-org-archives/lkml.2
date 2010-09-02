Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0IBHzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:55:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:46210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0IBHzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:55:37 -0400
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and
 functions
From: Peter Zijlstra <peterz@infradead.org>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <4C7F39B3.4000901@cn.fujitsu.com>
References: <4C7E2CA9.9060702@cn.fujitsu.com>
	 <1283354736.2059.1206.camel@laptop>  <4C7F39B3.4000901@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Sep 2010 09:55:19 +0200
Message-ID: <1283414119.2059.1785.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 13:44 +0800, Miao Xie wrote:
> On Wed, 01 Sep 2010 17:25:36 +0200, Peter Zijlstra wrote:
> > On Wed, 2010-09-01 at 18:36 +0800, Miao Xie wrote:
> >> + * This program is free software; you can redistribute it and/or modify it
> >> + * under the terms of the GNU General Public License as published by the Free
> >> + * Software Foundation; either version 2.1 of the License, or (at your option)
> >> + * any later version.
> >
> > The kernel is GPL v2, see COPYING. GPL v2.1 is not a suitable license.
> 
> Ok, I will change it.

Are you allowed to change it? from what I understand the FSF owns the
copyright of that code, that least, that's what the preamble I cut away
implied.


