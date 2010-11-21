Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0KUVs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:48:26 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab0KUVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=khdrCnsrOOHqZAMK4LbRGypsELd2Uib2zyo2qRg4YxAVDn6KTsBxOWSw30oq367zO7
         rAS5PppBf6lBwDKn2QSQ==
Date: Sun, 21 Nov 2010 13:48:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 2/2] mm: add node hotplug emulation
In-Reply-To: <20101121173438.GA3922@suse.de>
Message-ID: <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com>
References: <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com> <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
 <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com> <20101121173438.GA3922@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010, Greg KH wrote:

> But as this is a debugging thing, why not just put it in debugfs
> instead?
> 

Ok, I think Paul had a similar suggestion during the discussion of 
Shaohui's patchset.  I'll move it, thanks.
