Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2EILLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:11:38 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35103 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2EILLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:11:35 -0400
References: <1336515735.2097.23.camel@shrek.rexursive.com> <4FAA2673.50007@linux.vnet.ibm.com> <1336560579.2097.32.camel@shrek.rexursive.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1336560579.2097.32.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Wed, 09 May 2012 21:11:30 +1000
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Message-ID: <aba7b996-df0e-420c-b2eb-d32881660fe8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bojan Smojver <bojan@rexursive.com> wrote:

>Honest answer - I have absolutely no idea. I've seen the code of
>suspend-utils (i.e. user mode stuff) and it seems to me that it does
>exactly this. Could be wrong of course, just like many times before.

What makes me think that this may not be that bad is the fact that post-resume, it will actually be hibernation code that will be unwinding things. So like this: prepare for hibernation, create image, suspend to memory (equivalent to hibernation failure of some kind, really), resume from memory, unwind from unsuccessful hibernation.

No?

-- 
Bojan
