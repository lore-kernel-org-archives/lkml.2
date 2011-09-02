Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab1IBFzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:55:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab1IBFzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:55:01 -0400
Date: Fri, 2 Sep 2011 09:54:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vasiliy Kulikov <segoon@openwall.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110902055455.GL30615@sun>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <20110831090612.GA3253@albatros>
 <20110831112642.GI25465@sun>
 <20110831140416.GA17626@shutemov.name>
 <20110831142622.GB30615@sun>
 <20110831151023.5b7e12da.akpm@linux-foundation.org>
 <20110901104633.GG30615@sun>
 <20110901154946.b43ba91b.akpm@linux-foundation.org>
 <20110901230440.GA4432@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901230440.GA4432@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 01:04:40AM +0200, Tejun Heo wrote:
> On Thu, Sep 01, 2011 at 03:49:46PM -0700, Andrew Morton wrote:
> > The most robust implementation here is to allocate a large number of
> > small objects - one per vma.  A list would be a suitable way of
> > managing them.
> 
> Or just use flex_array?
> 

Hey, looks interesting! I'll check. Thanks for the point!

	Cyrill
