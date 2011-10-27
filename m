Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1J0M5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:57:36 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60795 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1J0M5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:57:35 -0400
Subject: Re: Linux 3.0.8
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
In-Reply-To: <20111027120840.GA6863@suse.de>
References: <20111025051928.GA7997@kroah.com>
	 <1319716969.20488.14.camel@x61.thuisdomein> <20111027120840.GA6863@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 14:57:25 +0200
Message-ID: <1319720245.20488.30.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 14:08 +0200, Greg KH wrote:
> Can you verify that the end result from your patch, and my patch,
> produces the same tree?  If not, we need to resolve that.

Yes, they do produce the same tree.

Ie, if I commit the changes introduced by your patch-3.0.8 onto v3.0 I
get a HEAD that is identical to v3.0.8 (as a git diff between these two
shows nothing). And the (git diff) patches I can generate locally
between v3.0 and either that HEAD or v3.0.8 are identical (but not
identical to your patch-3.0.8, obviously).

So, it's just that git generated a different patch on your system than
it does on mine.

Thanks,


Paul Bolle

