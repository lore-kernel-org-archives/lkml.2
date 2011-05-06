Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1EFWh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:37:29 -0400
Received: from outmail019.snc4.facebook.com ([66.220.144.151]:44933 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031Ab1EFWh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:37:28 -0400
Date: Fri, 6 May 2011 15:37:27 -0700
From: Arun Sharma <asharma@fb.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arun Sharma <asharma@fb.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add $KERNELRELEASE to firmware install path
Message-ID: <20110506223727.GA29011@dev1756.snc6.facebook.com>
References: <20110505173939.GA20575@dev1756.snc6.facebook.com>
 <4DC3CA39.30806@suse.cz>
 <1304677113.20656.2.camel@i7.infradead.org>
 <20110506184438.GA30417@dev1756.snc6.facebook.com>
 <1304708557.20656.49.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304708557.20656.49.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 08:02:36PM +0100, David Woodhouse wrote:
> On Fri, 2011-05-06 at 11:44 -0700, Arun Sharma wrote:
> > 
> > Without this change, if you have two kernel rpms/debs from different
> > kernel versions installed, they'll result in a namespace conflict
> > (rpm/deb install will fail), which gets resolved by this patch. 
> 
> The packages are broken then. They shouldn't include *any* files
> in /lib/firmware.
> 
> Fix *that*, and the problem goes away.

Sounds good.

Michal: Should I send you a patch that drops /lib/firmware?

 -Arun
