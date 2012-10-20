Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2JTKPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:15:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50828 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2JTKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:15:30 -0400
MIME-Version: 1.0
In-Reply-To: <1350646863.30157.13.camel@twins>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
	<20121018172021.0b1f6e3d@cuia.bos.redhat.com>
	<1350646863.30157.13.camel@twins>
Date: Sat, 20 Oct 2012 03:15:28 -0700
Message-ID: <CANN689G1EpuUMYj6c2iKf4Qoyo1ooDhQecm-Qgih5_f3S=Gd-w@mail.gmail.com>
Subject: Re: [PATCH 2/2] rename NUMA fault handling functions
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, aarcange@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 4:41 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-10-18 at 17:20 -0400, Rik van Riel wrote:
>> Having the function name indicate what the function is used
>> for makes the code a little easier to read.  Furthermore,
>> the fault handling code largely consists of do_...._page
>> functions.
>
> I don't much care either way, but I was thinking walken might want to
> use something similar to do WSS estimation, in which case the NUMA name
> is just as wrong.

Right now my working set estimation only uses A bits, so let's not
make that a concern here.

I think the _numa names are a bit better than _prot_none, but still a
bit confusing. I don't have any great suggestions but I think there
should at least be a comment above pte_numa() that explains what the
numa ptes are (the comment within the function doesn't qualify as it
only explains how the numa ptes are different from the ones in
PROT_NONE vmas...)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
