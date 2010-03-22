Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0CVUzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:55:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40982 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0CVUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:55:44 -0400
Date: Mon, 22 Mar 2010 21:55:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: James Kosin <jkosin@intcomgrp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [OT] Style Issues / Concerns
Message-ID: <20100322205543.GB20695@one.firstfloor.org>
References: <4BA7CCC5.5020302@intcomgrp.com> <87wrx45d4d.fsf@basil.nowhere.org> <4BA7D433.1050109@intcomgrp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7D433.1050109@intcomgrp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 04:33:55PM -0400, James Kosin wrote:
> On 3/22/2010 4:13 PM, Andi Kleen wrote:
> > James Kosin <jkosin@intcomgrp.com> writes:
> >   
> >> Before everyone jumps in at once, this is a simple example that will
> >> produce a compiler error about the misplaced else.  However if there are
> >> many if statements above this that may allow the else to be paired up
> >> with it then the code will compile and there will be a serious and very
> >> difficult bug in the code that will take days or months to find.
> >>     
> > Modern editors with auto indent mode makes it actually very easy
> > to find such bugs.
> >
> > Also checkpatch.pl checks for it now I believe.
> >   
> Thanks for the speedy reply.
> 
> Does this mean developers need to install X or some graphical
> environment now to develop the kernel?

Modern was perhaps the wrong word. emacs, vim support that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
