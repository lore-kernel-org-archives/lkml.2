Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0CVK6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:58:17 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39019 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754538Ab0CVK6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:58:15 -0400
Date: Mon, 22 Mar 2010 11:58:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, gregkh@suse.de, greg@kroah.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
Message-ID: <20100322105814.GA31753@atrey.karlin.mff.cuni.cz>
References: <1269210658-9518-1-git-send-email-lindley@coyote.org> <4BA71949.9040809@cs.helsinki.fi> <4BA73C4C.4020708@coyote.org> <84144f021003220257k1bd88315x3eb21057b4696a8f@mail.gmail.com> <4BA74CA2.7070305@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA74CA2.7070305@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2010-03-22 10:57, Pekka Enberg wrote:
> > On Mon, Mar 22, 2010 at 11:45 AM, Lars Lindley <lindley@coyote.org> wrote:
> >> On 2010-03-22 08:16, Pekka Enberg wrote:
> >>>> +unsigned char Wb35Reg_initial(struct hw_data *HwData);
> >>>
> >>> Lets avoid CamelCase for the arguments so "hw_data" here, for example. I
> >>> see the same thing elsewhere in this patch as well.
> >>>
> >> I thought struct hw_data *hw_data looked a bit confusing..Thats why I left
> >> CamelCase alone for now. I can make it like that if you want..
> > 
> > Yes please.
> > 
> 
> 
> Here's a new patch against master that fixes CamelCase too.
> 
> 
> 
> [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
> 
> I fixed the checkpatch things except a couple of long lines.
> I also removed hungarian notation and CamelCase from the argument names
> and some "commented away" code.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
