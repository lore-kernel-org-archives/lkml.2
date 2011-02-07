Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1BGM0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:26:30 -0500
Received: from shutemov.name ([188.40.19.243]:47944 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1BGM03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:26:29 -0500
Date: Mon, 7 Feb 2011 14:26:28 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH, v5 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110207122628.GC11712@shutemov.name>
References: <1297071962-11654-1-git-send-email-kirill@shutemov.name>
 <1297071962-11654-3-git-send-email-kirill@shutemov.name>
 <20110207100624.GB28911@balbir.in.ibm.com>
 <20110207105730.GA11852@shutemov.name>
 <20110207121430.GM27729@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207121430.GM27729@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 05:44:30PM +0530, Balbir Singh wrote:
> * Kirill A. Shutemov <kirill@shutemov.name> [2011-02-07 12:57:30]:
> 
> > On Mon, Feb 07, 2011 at 03:36:24PM +0530, Balbir Singh wrote:
> > > 2. Can there be an overlap in the ranges?
> > 
> > What overlap do you mean?
> > There is only one rule: parent's range should be wider then child's.
> 
> Between the children, can we have something like
> 
>         10-200
>         /    \
>        /      \
>       V        V
>    10-110    100-200

Yes, sure.

-- 
 Kirill A. Shutemov
