Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1JGSSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:18:31 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:38267 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1JGSS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:18:29 -0400
Date: Fri, 7 Oct 2011 20:18:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Williams <steveicarus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MODULE_LICENSE("GPL") not working for me
Message-ID: <20111007181826.GA20210@merkur.ravnborg.org>
References: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com> <CAO3ZPq2RUjW7VQQSoN-S7QDuTYdCMuDfoykHSeXwr19MTnCb_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO3ZPq2RUjW7VQQSoN-S7QDuTYdCMuDfoykHSeXwr19MTnCb_A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:20:46AM -0700, Stephen Williams wrote:
> On Thu, Oct 6, 2011 at 3:30 PM, Stephen Williams <steveicarus@gmail.com> wrote:
> > I have some large drivers for use in embedded arm systems, and
> > I want them to be GPL, because I want to use some symbols exported
> > as GPL, and also because I just wanna. But it is not working for
> > me. I've attached my Makefile. I'm building from outside the kernel
> > tree, but that should be OK. (right?) I'm using the following script to
> > actually build:
> 
> More information: I can see that the vidfor.o object file, indeed
> none of my *.o files, have a .modinfo section. In other situations
> where the licens stamp works, the .modinfo section is present.
> I'm using the CodeSourcery build of the arm toolchain, and in
> the simple cases (module that is a single source file) the
> modinfo information works. Hmm...

I lost the original mail...
Could you try to post the output of make V=2 when you build your module
and the Makefile fragment again.

	Sam
