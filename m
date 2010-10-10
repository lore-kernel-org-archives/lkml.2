Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab0JJVR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 17:17:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41685 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0JJVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 17:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xipt0jxvfL3Bi0C/K+kcP4pwjorVANCGsmOEYQQ6XBMnUnH0fgRer5OPngD0JEn8jK
         vFTgPHK7fdzLZmr6rvkVS2LTbj7IjHJfhoajTEEvurvE1F5Ly1y42W7WuVPkmy5YVFbD
         7VfQUc0O/nMjxY8sOiZ3rYAjVeNoKV/HnWzSY=
Date: Sun, 10 Oct 2010 14:17:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wacom: fix pressure in Cintiq 21UX2
Message-ID: <20101010211721.GA27553@core.coreip.homeip.net>
References: <20101008141627.GN341@redhat.com>
 <AANLkTin9zgZnoNzpvzMrEfTkSRoom1DhwUhUjxWbNNF4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin9zgZnoNzpvzMrEfTkSRoom1DhwUhUjxWbNNF4@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 11:20:18AM -0700, Ping Cheng wrote:
> On Fri, Oct 8, 2010 at 7:16 AM, Aristeu Rozanski <aris@redhat.com> wrote:
> > Currently the pressure range in Cintiq 21UX2 is limited to half of the
> > supported. This patch fixes the problem.
> >
> > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> Acked-by: Ping Cheng <pingc@wacom.com>
> 
> Thank you Aristeu.
> 
> Dmitry, this patch should be backported since it is a bug fix.
> 

OK, will mark it for stable.

Thanks.

-- 
Dmitry
