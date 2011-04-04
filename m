Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1DDXOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:14:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028Ab1DDXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:14:29 -0400
Date: Mon, 4 Apr 2011 16:15:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        containers@lists.linux-foundation.org, Nathan Lynch <ntl@pobox.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-Id: <20110404161550.1ab5347e.akpm@linux-foundation.org>
In-Reply-To: <20110404215511.GA27628@count0.beaverton.ibm.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
	<1298936432-29607-6-git-send-email-ntl@pobox.com>
	<20110403190324.GD15044@hallyn.com>
	<1301929228.31531.39.camel@tp-t61>
	<20110404151017.GA4857@hallyn.com>
	<1301931608.31531.49.camel@tp-t61>
	<20110404162753.GA3456@hallyn.com>
	<20110404104119.78189678.akpm@linux-foundation.org>
	<20110404185119.GB4782@peq.hallyn.com>
	<20110404124222.fd5eb85b.akpm@linux-foundation.org>
	<20110404215511.GA27628@count0.beaverton.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 14:55:11 -0700 Matt Helsley <matthltc@us.ibm.com> wrote:

> However I think we need some review before we continue modifying it. We
> had a minimal patch set which evolved into the current maximal set. It
> never really got the reviews outside our little group that it needed.
> Now we're back with a new minimal patch set. You're asking us to do the same
> thing and expect different results -- stack more patches on top and expect to
> get it reviewed. OK, but what reason do we have to believe this time will be
> any different?

None whatsoever.  It could be that the two sets "a sufficiently useful
c/r implementation" and "a c/r implementation which will be acceptable"
have no intersection.  IOW, there is no solution.

But I haven't looked at c/r patches in quite some time, hence the
hand-waving and useless platitudes.

