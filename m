Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0HIMV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:21:58 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60223 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0HIMV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:21:57 -0400
Date: Mon, 9 Aug 2010 13:21:47 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <david.s.daney@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: remove RELOC_HIDE on __pa_symbol
Message-ID: <20100809122147.GA23053@linux-mips.org>
References: <1281297456-2711-1-git-send-email-namhyung@gmail.com>
 <4C5F8ED8.90301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5F8ED8.90301@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 10:15:04PM -0700, David Daney wrote:

>  On 08/08/2010 12:57 PM, Namhyung Kim wrote:
> >remove unneccessary use of RELOC_HIDE(). It does simple addition of ptr and
> >offset and in this case (offset 0) does practically nothing. It does NOT do
> >anything with linker relocation.
> >
> 
> Maybe you could explain in more detail the problems you are having
> with the current definition of __pa_symbol().  I would be hesitant
> to change this bit of black magic unless there is a concrete problem
> you are trying to solve.

RELOC_HIDE was originally added by 6007b903dfe5f1d13e0c711ac2894bdd4a61b1ad
(lmo) rsp. 8431fd094d625b94d364fe393076ccef88e6ce18 (kernel.org).  A
discussion can be found in lkml posting
a2ebde260608230500o3407b108hc03debb9da6e62c@mail.gmail.com> which is
archived at

    http://lists.linuxcoding.com/kernel/2006-q3/msg17360.html

I felt this was dubious by the time it was added and probably should go?

  Ralf
