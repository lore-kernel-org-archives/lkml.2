Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab0KLSEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:04:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49521 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab0KLSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TslhtvaJ6d+erD/4Equ9fSHe9t7evPrAloP5UBHpa2EEoG0gU/6bRxJLDlB1z2bwF4
         qtP7kMvRbrk6Rmg4RjfgDN0wyspvgJUnoh8bBdimU5M4Gxj3kKt88PZ34ol7+TOHHnjl
         XQM9mGQ01SrM9WNPgVTYCgCjxkzvfPfHqyDUU=
Date: Fri, 12 Nov 2010 21:04:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86: Remove old nmi_watchdog
Message-ID: <20101112180409.GA20425@lenovo>
References: <1289578944-28564-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289578944-28564-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:22:22AM -0500, Don Zickus wrote:
>
> Ingo asked me to remove the old nmi_watchdog to minimize the amount of
> code duplication we have to do for recent fixes.  All the functionality
> needed by the old nmi watchdog should be available in perf now.
> 

 Hi Don, moving out old nmi-watchdog in a sake of new perf based one is
definitely a win I believe. And I didn't find anything suspicious in patch
series as well.

Though it's a bit pity that we eventually drop old io-apic based watchdog ;)
I never used it personally since apic on mine cpu works well enough but still
I think the io-apic watchdog code was pretty interesting to read and I believe
it worked well with old pit timer.

> Compile tested for 32/64 bit with the lockup detector turned on and off.
> Tested on 32/64 bit machines to make sure they still boot properly.

ok, great done!

 Cyrill
