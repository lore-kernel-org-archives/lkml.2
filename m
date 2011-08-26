Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1HZHWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:22:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54815 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1HZHWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:22:19 -0400
Subject: Re: Subject: [PATCH V7 4/4] mm: frontswap: config and doc files
From: Sasha Levin <levinsasha928@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com
In-Reply-To: <20110823145855.GA23251@ca-server1.us.oracle.com>
References: <20110823145855.GA23251@ca-server1.us.oracle.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 26 Aug 2011 10:22:10 +0300
Message-ID: <1314343330.3647.32.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to note that I found the documentation very useful, it made
it very easy to understand whats going on.

On Tue, 2011-08-23 at 07:58 -0700, Dan Magenheimer wrote:
> +In the virtual case, the whole point of virtualization is to statistically
> +multiplex physical resources acrosst the varying demands of multiple
				across
> +virtual machines.  This is really hard to do with RAM and efforts to do

-- 

Sasha.

