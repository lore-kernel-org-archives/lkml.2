Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0L3LeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 06:34:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33427 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab0L3Ld6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 06:33:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fk7g83GGW3b91DrotwMI7mIXQKoXt4uwEdt5AWZP7m3Is/0ThszzZLtHQ7bzwJeOAx
         c2qNBoubt054KfK35MS/uh6gyW2uaTH5L0i5Kw/nmBxQM9TLKMhcT5h1lZ9w2rs87bJe
         umDnqHJbs3k2Mcu75Wj7kJ0rrt4H3fQvYwV+w=
Date: Thu, 30 Dec 2010 12:33:54 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping
 between 32 and 64bit
Message-ID: <20101230113354.GC18831@htj.dyndns.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
 <1293536929-31683-14-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1012281231070.8883@chino.kir.corp.google.com>
 <20101229105253.GK488@htj.dyndns.org>
 <4D1B8DC8.6000104@zytor.com>
 <4D1BB092.7030609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1BB092.7030609@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 02:05:06PM -0800, H. Peter Anvin wrote:
> On 12/29/2010 11:36 AM, H. Peter Anvin wrote:
> > On 12/29/2010 02:52 AM, Tejun Heo wrote:
> >> On Tue, Dec 28, 2010 at 12:35:45PM -0800, David Rientjes wrote:
> >>> This is going to conflict with a387e95a ("") in x86/numa, so you'll need 
> >>> the following hunk for acpi_fake_nodes().  I'm not sure why this patchset 
> >>> is being based on x86/apic-cleanup rather than x86/numa?
> >>
> >> Because several patches from the patchset have already been committed
> >> into x86/apic-cleanup.  Thomas, Peter, if this needs to be rebased
> >> somewhere, let me know.
> >>
> > 
> > x86/numa is already a dependent branch (on x86/amd-nb), so I'm fine
> > merging x86/apic-cleanup into that branch and then if you could rebase
> > it on top of the new x86/numa then I'll push it out tomorrow.
> > 
> > OK?
> > 
> 
> I have pushed out this merge onto x86/numa, so waiting for your rebase.
>  If you don't have time, then I'll rebase.

Will rebase & repost soon.

Thanks.

-- 
tejun
