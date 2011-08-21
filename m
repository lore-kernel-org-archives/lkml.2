Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1HUXN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:13:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49483 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1HUXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:13:58 -0400
Date: Mon, 22 Aug 2011 01:13:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110821231354.GL25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 06:28:28PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Fri, Aug 19, 2011 at 7:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Reposting due to popular demand. Several other people are running
> > into the same problem with all kinds of software.
> >
> > Only change is rebase against current master.
> >
> FWIW, couldn't this be made a boot option ?

init=/script/that/runs/uname26/sbin/init

-Andi
