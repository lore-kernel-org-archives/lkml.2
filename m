Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935508Ab1KJEuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:50:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38313 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab1KJEuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:50:02 -0500
Date: Wed, 9 Nov 2011 20:49:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nai Xia <nai.xia@gmail.com>, Russell King <linux@arm.linux.org.uk>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
In-Reply-To: <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111092048520.27280@chino.kir.corp.google.com>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com> <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Nai Xia wrote:

> Did this patch get merged at last, or on this way being merged, or
> just dropped ?
> 

I thought we were waiting to find out if it caused a problem on arm.  
Either Russell should be able to clarify that or a couple months in 
linux-next.
