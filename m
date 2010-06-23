Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0FWTKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:10:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55794 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0FWTKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:10:12 -0400
Date: Wed, 23 Jun 2010 21:10:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Kees Cook <kees.cook@canonical.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] security: Yama LSM
Message-ID: <20100623191007.GD15787@basil.fritz.box>
References: <20100623065236.GH5876@outflux.net>
 <877hlqas9e.fsf@basil.nowhere.org>
 <20100623145437.GJ5876@outflux.net>
 <20100623153408.GA15787@basil.fritz.box>
 <20100623165936.661744f8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623165936.661744f8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 04:59:36PM +0100, Alan Cox wrote:
> > > I actually think this is a flaw in get_task_comm.  (Though actually it's
> > > the fault of terminals if they process dangerous escape sequences. Worst
> > > case tends to just be confusing output, but that's not important --
> > > nothing should spew non-printables regardless.)  Would a patch to
> > > get_task_comm be accepted to replace non-printables with "?" or something
> > > when filling the buffer?
> > 
> > Probably makes sense, although you might annoy someone who wants Kanji
> > process names in UTF-8 or similar.
> 
> The task name is irrelevant, user controlled information. It's not
> really ideal for use in security logging.

Yes but the pid only is normally completely useless, because nobody
knows afterwards what some old pid was.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
