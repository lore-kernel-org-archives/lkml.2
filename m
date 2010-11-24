Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0KXPp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:45:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52797 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0KXPpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=W2ik5UkIN9WFDmhpTVpBJ1PwvFLAMYET6qvpwjpk1bwcKQM3vgEBp7lWkIeVzvd6uw
         NSmHBRyMLpwctPLTC2saBlyRaWEN/IHu6/8B9AtWA7/UbHriZEiTC8IOqnbs8oaSV2dn
         F3SBega076dLaCKDjWsaT6UH+nB3OYjb9Y5GU=
MIME-Version: 1.0
In-Reply-To: <1290607413.12457.44.camel@concordia>
References: <1290607413.12457.44.camel@concordia>
From: Timur Tabi <timur@freescale.com>
Date: Wed, 24 Nov 2010 09:44:52 -0600
X-Google-Sender-Auth: v2M0gZXh0aSUfveuAKJWuLav6xU
Message-ID: <AANLkTikiTdw1rTxO-wxmutm=vvcxGdTKKCs_roEA7uE-@mail.gmail.com>
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
To: michael@ellerman.id.au
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 8:03 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:

> Personally I'm a bit ambivalent about it, the OF name is a bit wrong so
> it would be nice to get rid of, but it's a lot of churn.
>
> So I'm hoping people with either say "YES this is a great idea", or "NO
> this is stupid".

Well, my vote is "no".  I wouldn't call it stupid, but I do think it's
a bad idea.

In general, I don't like renaming functions, because it causes
complications with merges and porting code across kernel versions.  It
also forces me to re-remember things.

And especially in this case, the churn is too great.  You're affecting
files across multiple subsystems and architectures.

-- 
Timur Tabi
Linux kernel developer at Freescale
