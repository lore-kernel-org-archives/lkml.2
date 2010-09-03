Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0ICPu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:50:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37441 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0ICPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AuIMN7mPR5FFpw4QXHIpgr9Nmuy7ILI2YU8tahHjYDujtMEecY0BaZPWwQXKLi0kou
         xrGnqJ8qZpm4OGUBKBGnZItcg0GwwFgBBjLimvqODO+BWgFxL3F90LYocw1d+Ep+VZmW
         vf3pGB4s0eKNt1FhFV0UhdByl4Sf+MsMz4oVY=
MIME-Version: 1.0
In-Reply-To: <201009031652.56476.ptesarik@suse.cz>
References: <201008271537.35709.ptesarik@suse.cz>
	<201009031104.38433.ptesarik@suse.cz>
	<201009031635.25093.ptesarik@suse.cz>
	<201009031652.56476.ptesarik@suse.cz>
Date: Fri, 3 Sep 2010 08:50:53 -0700
Message-ID: <AANLkTikZRiQ5jCpgp42LxtXb_S52sSUy7KP_=vZ3z4Tf@mail.gmail.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
From: Tony Luck <tony.luck@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 7:52 AM, Petr Tesarik <ptesarik@suse.cz> wrote:
> Anyway, if a global TLB flush is necessary to trigger the bug, it would also
> explain why we couldn't reproduce it in user-space.

Perhaps ... I did explore the TLB in one variant of my user mode test I added
a pointer-chasing routine that looked at enough pages to clear out the TLB.
Not quite the same as a flush - but close.  It didn't help at all.

-Tony
