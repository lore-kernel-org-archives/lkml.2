Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2LGWhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:37:38 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35318 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2LGWhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:37:37 -0500
Message-ID: <50C26FA7.9010000@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 14:37:27 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] Debugging: Keep track of page owners
References: <20121207212417.FAD8DAED@kernel.stglabs.ibm.com> <20121207142614.428b8a54.akpm@linux-foundation.org>
In-Reply-To: <20121207142614.428b8a54.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120722-2876-0000-0000-000002E814F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:26 PM, Andrew Morton wrote:\
> I have cunningly divined the intention of your update and have queued
> the below incremental.  The change to
> pagetypeinfo_showmixedcount_print() was a surprise.  What's that there
> for?

Do you mean to ask why it's being modified at all here in this patch?
It's referenced in the changelog a bit.  I believe it came from Mel at
some point.  I didn't do much to that portion, but I happily drug those
hunks along with my forward port.  I believe it's virtually all the same
as what you posted here:

	https://bugzilla.kernel.org/show_bug.cgi?id=50181


