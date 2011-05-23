Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab1EWUVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:21:32 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:44700 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934083Ab1EWUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:21:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=erx2ZUbZoKlrcxI71W5lJoDDnqmQRn8rZP0Fj/RHdkmhaosGq5TBPNiVaPml9Z6+QDjwpmoYPCQm1DyJf53hoWKKG1TnUmZ6vsKXYq1l3W9c0UhpyZz2jLE+t+nGjlHE;
Date: Mon, 23 May 2011 13:21:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
Message-Id: <20110523132126.3f6ead5f.rdunlap@xenotime.net>
In-Reply-To: <alpine.LFD.2.02.1105232121010.3078@ionos>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<alpine.LFD.2.02.1105232121010.3078@ionos>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 21:25:25 +0200 (CEST) Thomas Gleixner wrote:

> On Mon, 23 May 2011, Linus Torvalds wrote:
> > PS. The voices in my head also tell me that the numbers are getting
> > too big. I may just call the thing 2.8.0. And I almost guarantee that
> > this PS is going to result in more discussion than the rest, but when
> > the voices tell me to do things, I listen.
> 
> So the voices tell you to avoid .42 ?

They tell him to avoid the question to which 42 is the answer.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
