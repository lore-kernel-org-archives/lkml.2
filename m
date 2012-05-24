Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab2EXOjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:39:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:39028 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab2EXOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:39:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170889804"
Date: Thu, 24 May 2012 15:54:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ming Lei <tom.leiming@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.4+ tty lockdep trace
Message-ID: <20120524155457.56e37df2@bob.linux.org.uk>
In-Reply-To: <CA+1xoqeD3yyOgmLe_eQ_PS=HJA=93Syidtk6rq-K9dBoC-DOzQ@mail.gmail.com>
References: <20120523002645.GA3490@redhat.com>
	<CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
	<CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
	<20120524121056.24fbdcdb@pyramind.ukuu.org.uk>
	<CA+1xoqegLYLsP5yWw7d7oMngUSgZjXePJu_b6E-yw4aBE8Qhgg@mail.gmail.com>
	<CA+1xoqc3MrwfDnf9iCRLCedapZOtOfmBb6E84ORgwmdP1fx8QA@mail.gmail.com>
	<CA+1xoqeD3yyOgmLe_eQ_PS=HJA=93Syidtk6rq-K9dBoC-DOzQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 13:24:56 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> On Thu, May 24, 2012 at 1:21 PM, Sasha Levin
> <levinsasha928@gmail.com> wrote:
> > On Thu, May 24, 2012 at 1:20 PM, Sasha Levin
> > <levinsasha928@gmail.com> wrote:
> >> On Thu, May 24, 2012 at 1:10 PM, Alan Cox
> >> <alan@lxorguk.ukuu.org.uk> wrote:
> >>>> I'm still seeing the warning with this patch:
> >>>
> >>> Can you attach the trace that went with the trigger as well ?
> >>
> >> Ofcourse, attached as a file.
> >
> > Heh, this was a different one as well. I'll try to get the one I got
> > in the morning again.
> 
> And here is the second one attached as well, so these are two
> different warnings I get with the new version.


I'm somewhat baffled by this one. Can lockdep be fooled by an object
being freed and reallocated at the same address, Is there any markup
that should be present to avoid that ?

Alan
