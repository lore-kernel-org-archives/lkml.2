Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2EYCc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:32:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2EYCc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:32:26 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=UiK3xWjrDlEGFpFm9YIA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Thu, 24 May 2012 22:32:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ming Lei <tom.leiming@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.4+ tty lockdep trace
Message-ID: <20120525023222.GC30024@home.goodmis.org>
References: <20120523002645.GA3490@redhat.com>
 <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
 <CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
 <20120524121056.24fbdcdb@pyramind.ukuu.org.uk>
 <CA+1xoqegLYLsP5yWw7d7oMngUSgZjXePJu_b6E-yw4aBE8Qhgg@mail.gmail.com>
 <CA+1xoqc3MrwfDnf9iCRLCedapZOtOfmBb6E84ORgwmdP1fx8QA@mail.gmail.com>
 <CA+1xoqeD3yyOgmLe_eQ_PS=HJA=93Syidtk6rq-K9dBoC-DOzQ@mail.gmail.com>
 <20120524155457.56e37df2@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524155457.56e37df2@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 03:54:57PM +0100, Alan Cox wrote:
> On Thu, 24 May 2012 13:24:56 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
> > 
> > And here is the second one attached as well, so these are two
> > different warnings I get with the new version.
> 
> 
> I'm somewhat baffled by this one. Can lockdep be fooled by an object
> being freed and reallocated at the same address, Is there any markup
> that should be present to avoid that ?

Sasha,

Did you apply Ming's second patch. His first patch (the one referenced
in the email) didn't have the unlock fixup.

--Steve

