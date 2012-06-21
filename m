Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463Ab2FUXfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:35:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab2FUXe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:34:59 -0400
Date: Thu, 21 Jun 2012 16:34:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2012-06-21-16-20 uploaded
Message-Id: <20120621163458.89459d7a.akpm@linux-foundation.org>
In-Reply-To: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 16:21:49 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-06-21-16-20 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/

Exciting updates to http://www.ozlabs.org/~akpm/mmotm/mmotm-readme.txt:

: The directory http://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
: contains daily snapshots of the -mm tree.  It is updated more frequently
: than mmotm, and is untested.

It takes me 1.5 hours to 1.5 days to do a -mm release, depending on how
many screwups people have been merging and sending.  This makes the
releases less frequent than I'd like.

So I will do daily dumps of the -mm patches into
http://www.ozlabs.org/~akpm/mmots/.  They are the same as the mmotm
patches (use the same script), except they will be unannounced and
untested.
