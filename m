Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2EOKwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:52:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:47513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2EOKwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:52:02 -0400
Message-ID: <1337079117.27694.28.camel@twins>
Subject: Re: [34-longterm 167/179] futex: Fix regression with read only
 mappings
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 12:51:57 +0200
In-Reply-To: <alpine.LSU.2.00.1205142126180.2196@eggly.anvils>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
	 <1337048075-6132-168-git-send-email-paul.gortmaker@windriver.com>
	 <alpine.LSU.2.00.1205142126180.2196@eggly.anvils>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 21:38 -0700, Hugh Dickins wrote:
> I don't know: I'm not NAKking it, I'm just waving a reddish flag,
> and hoping that Peter will remember more, and have something more
> constructive to say, than I can think of at this moment. 

Ha! you're very optimistic :-)

going by git log kernel/futex.c on a recent kernel the proposed patch
should indeed be followed by your patch, but I can't seem to find more
relevant patches.


