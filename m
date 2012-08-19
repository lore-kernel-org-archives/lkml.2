Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2HSVUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:20:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:32251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2HSVUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,794,1336374000"; 
   d="scan'208";a="135976157"
From: Andi Kleen <andi@firstfloor.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	<CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	<1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>
	<1345383264.4441.56.camel@tunafish>
	<20120819120254.GA2369@pompeji.miese-zwerge.org>
	<1345390432.2716.34.camel@tunafish> <20120819210455.GA9208@thunk.org>
Date: Sun, 19 Aug 2012 14:20:15 -0700
In-Reply-To: <20120819210455.GA9208@thunk.org> (Theodore Ts'o's message of
	"Sun, 19 Aug 2012 17:04:55 -0400")
Message-ID: <m2hary8tps.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:
>
> In practice, the solution of using either FAT 

When the answer is FAT the question usually didn't make much sense.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
