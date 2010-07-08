Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0GHLX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:23:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab0GHLX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:23:28 -0400
Subject: Re: FYI: mmap_sem OOM patch
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100708200324.CD4B.A69D9226@jp.fujitsu.com>
References: <20100708195421.CD48.A69D9226@jp.fujitsu.com>
	 <1278586921.1900.67.camel@laptop>
	 <20100708200324.CD4B.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 13:23:20 +0200
Message-ID: <1278588200.1900.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 20:06 +0900, KOSAKI Motohiro wrote:
> > [ small note on that we really should kill __GFP_NOFAIL, its utter
> > deadlock potential ]
> 
> I disagree. __GFP_NOFAIL mean this allocation failure can makes really
> dangerous result. Instead, OOM-Killer should try to kill next process.
> I think. 

Say _what_?! you think NOFAIL is a sane thing? Pretty much everybody has
been agreeing for years that the thing should die.
