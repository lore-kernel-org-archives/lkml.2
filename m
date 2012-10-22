Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2JVJ12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2JVJ11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:27:27 -0400
Message-ID: <50851163.5050007@redhat.com>
Date: Mon, 22 Oct 2012 11:26:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@alien8.de>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
References: <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com> <20121021110329.GA7024@infradead.org> <20121021125933.GC19535@gmail.com> <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com> <20121021150305.GA26108@gmail.com> <20121021171543.GC20642@liondog.tnic> <20121021174041.GA240@x4> <20121021175108.GA3820@gmail.com> <20121021175422.GB240@x4> <20121021180458.GC240@x4> <20121021181031.GB4465@gmail.com>
In-Reply-To: <20121021181031.GB4465@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 08:10 PM, Ingo Molnar wrote:
> Ok, looks useful - will someone on the Qemu side script this up 
> and integrate it into the kernel in a useful form?

There are going to be as many options as there are users - people will
want different things, like block device assignment (for fs/iosched
people), device assignment (driver developers), cpu/memory topology, or
a dozen other things.  I think the best we can hope for is an example
script for people to copy and modify, otherwise we'll end up with the
same number of options that qemu has.

-- 
error compiling committee.c: too many arguments to function
