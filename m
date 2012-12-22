Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2LVCOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:14:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43281 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LVCOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:14:51 -0500
Date: Fri, 21 Dec 2012 21:14:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/13] x86, 64bit: Print init kernel lowmap correctly
Message-ID: <20121222021428.GB3468@phenom.dumpdata.com>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
 <1354089042-10023-13-git-send-email-yinghai@kernel.org>
 <20121221222619.GA1102@phenom.dumpdata.com>
 <CAE9FiQXsi5gj6QGp-rreH6Bqb6A5WTA6umFiiJ1mQFRp6u5ziw@mail.gmail.com>
 <20121221233942.GA2000@phenom.dumpdata.com>
 <CAE9FiQWwS=71dKBkSOHb5GEMfsRvSTo25A1jZ2+EhYwFo-Yo6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWwS=71dKBkSOHb5GEMfsRvSTo25A1jZ2+EhYwFo-Yo6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 03:52:53PM -0800, Yinghai Lu wrote:
> On Fri, Dec 21, 2012 at 3:39 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Fri, Dec 21, 2012 at 02:44:39PM -0800, Yinghai Lu wrote:
> >>
> >> maybe we can change the subject of this patch to:
> >>
> >> Subject: [PATCH] x86, 64bit: Don't set max_pfn_mapped wrong on native boot path
> >
> > Or the inverse.
> >
> > Set max_pfn_mapped correctly on non-native boot path?
> >
> > But this patch is not actually touching max_pfn_mapped - it is vaddr_end?
> 
> No,
> 
> it is 0 for native path
> 
> 
> > So maybe:
> >
> > Subject: For platforms to set max_pfn_mapped, take that under advisement when blowing away __ka page entries.
                           ^^ that

> 
> hard to understand.
