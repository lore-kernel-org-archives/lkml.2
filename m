Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0EaNjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:39:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:46825 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0EaNjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fzz2pWMDiPEAG3Rvh7uQ+oxw1Fm+dG0ZVx3iTbMAb75UW9pYVgRSQZnoBHyu1vS+Bb
         1V84GlIL8mKnflytriOkHgKljy7JXtz7EfPzZN5ZvNwQ8MZP8ug607lSM+9LyEJ0dH0w
         PI4VCuY4YyjJYQK0VYgmvA+D5UpZaTD/VecWw=
MIME-Version: 1.0
In-Reply-To: <20100529021624.GA2538@brick.ozlabs.ibm.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<4BACE827.4070006@gmail.com>
	<20100326170428.6c1ad66c@lxorguk.ukuu.org.uk>
	<4BB31E00.8060204@netservers.co.uk>
	<20100529021624.GA2538@brick.ozlabs.ibm.com>
Date: Mon, 31 May 2010 15:39:49 +0200
Message-ID: <AANLkTikXBEEWbi6LiC9fjeDfCK3VVePlyx1_Wtkf-wQg@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ben McKeegan <ben@netservers.co.uk>, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 04:16, Paul Mackerras <paulus@samba.org> wrote:

> If you fix up the indentation issues (2-space indent in some of the
> added code -- if you're using emacs, set c-basic-offset to 8), I'll
> ack it and hopefully DaveM will pick it up.

If no one submits it by tonight, I will probably send a cleaned-up
version of the alternative patch. Not that I want to steal anyone's
laurels, mind. But having it in mainline is better than not having
it in mainline.


Richard
