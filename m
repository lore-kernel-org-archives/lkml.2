Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1BVQgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:36:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54585 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab1BVQge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:36:34 -0500
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1298315270-10434-9-git-send-email-andi@firstfloor.org>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
	 <1298315270-10434-9-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 22 Feb 2011 08:36:26 -0800
Message-ID: <1298392586.9829.22566.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 11:07 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> I found it difficult to make sense of transparent huge pages without
> having any counters for its actions. Add some counters to vmstat
> for allocation of transparent hugepages and fallback to smaller
> pages.
> 
> Optional patch, but useful for development and understanding the system.

Very nice.  I did the same thing, splits-only.  I also found this stuff
a must-have for trying to do any work with transparent hugepages.  It's
just impossible otherwise.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>


