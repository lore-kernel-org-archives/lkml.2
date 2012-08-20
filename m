Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2HTRs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:48:27 -0400
Received: from mail.nonattached.net ([193.160.39.60]:59556 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2HTRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:48:19 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Dan Luedtke <mail@danrl.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120819210455.GA9208@thunk.org>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	 <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>
	 <1345383264.4441.56.camel@tunafish>
	 <20120819120254.GA2369@pompeji.miese-zwerge.org>
	 <1345390432.2716.34.camel@tunafish>  <20120819210455.GA9208@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Aug 2012 19:48:11 +0200
Message-ID: <1345484891.18266.21.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 17:04 -0400, Theodore Ts'o wrote:
> I also seriously question the niche of people who want to use a thumb
> drive to transfer > 4GB files.  Try it sometime and see what a painful
> user experience it is....
I don't know if LanyFS will it ever make, and to be honest there are
some corporations _not_ interested in its success, but if it makes it,
this process might be less painful in the future. At least I have to
try, and if we have a better solution in a few years, I'd be happy to
drop the idea and go back to watching my movies again.

However, I watch this thread and I take all the answers and mails into
consideration. You are the experts, and I appreciate you take the time
to discuss the general problem of compatibility and LanyFS in
particular.

I don't want to go to deep into the network vs. removable storage
discussion, although it is an interesting one. For some reason this
issue made a lot of noise, and I have to concentrate on replying to
various mails and modifying a lot of code eventually.

Thanks all of you for your comments.

Regards
Dan


-- 
Dan Luedtke
http://www.danrl.de

