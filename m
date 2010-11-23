Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab0KWIi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:38:29 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52160 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0KWIi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:38:28 -0500
Subject: Re: Sudden and massive page cache eviction
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter =?ISO-8859-1?Q?Sch=FCller?= <scode@spotify.com>,
        linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
In-Reply-To: <20101122161158.02699d10.akpm@linux-foundation.org>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	 <20101122161158.02699d10.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 23 Nov 2010 00:38:22 -0800
Message-ID: <1290501502.2390.7029.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 16:11 -0800, Andrew Morton wrote:
> > This latest observation we understand may be due to NUMA related
> > allocation issues, and we should probably try to use numactl to ask
> > for a more even allocation. We have not yet tried this. However, it
> is not clear how any issues having to do with that would cause sudden
> > eviction of data already *in* the page cache (on whichever node). 

You don't have anybody messing with /proc/sys/vm/drop_caches, do you?

That can cause massive, otherwise unprovoked page cache eviction.  

-- Dave

