Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab1AKBIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:08:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60141 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab1AKBIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:08:05 -0500
Date: Mon, 10 Jan 2011 17:08:01 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Important for fs devs: rcu-walk merged upstream
Message-ID: <20110111010800.GE4879@mail.oracle.com>
Mail-Followup-To: Nick Piggin <npiggin@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 01:54:47PM +1100, Nick Piggin wrote:
> The rcu-walk stuff can be more tricky for your filesystem
> to take advantage of.
> 
> If you supply a .d_revalidate, .permission, or .check_acl,
> then path walking is going to be slow and unscalable for
> you.

	Do you mean "as slow and unscalable as it has always been" or
"even slower now"?  A quick look suggests the former, but I wanted to be
sure.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

			http://www.jlbec.org/
			jlbec@evilplan.org
