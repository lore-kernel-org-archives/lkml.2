Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0FDVFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:05:44 -0400
Received: from mail-yw0-f187.google.com ([209.85.211.187]:56801 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0FDVFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PjYC0QLN1Zey4g2KOUgpfAhmha/Rk6oUtXcW4MUqHNrW/zPHt4dBQgxI5HkGIVTR9Z
         MwUNcAa1djQAymoLV8OGsffiimZL7zkP0WO8yQuiELM+pCfoZMW0zHC/y6KlzHlMt/Z3
         Gu/nolOK/edLKa9eidGP2n2N6MJjqeILIdoP8=
MIME-Version: 1.0
In-Reply-To: <20100604210313.GB7912@kroah.com>
References: <20100604204455.GD19761@kroah.com> <AANLkTilwzoUlastS0M9OMKuWgwmDE3VXdf2LCJxf50dV@mail.gmail.com> 
	<20100604210313.GB7912@kroah.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 4 Jun 2010 17:05:20 -0400
Message-ID: <AANLkTil9ucQcI5e3T3DgEeKOW99enBQksGqGy4htMIPB@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING fixes and new drivers for 2.6.35-git
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 17:03, Greg KH wrote:
> On Fri, Jun 04, 2010 at 04:48:23PM -0400, Mike Frysinger wrote:
>> On Fri, Jun 4, 2010 at 16:44, Greg KH wrote:
>> > apatard@mandriva.com (1):
>> >      staging: Add framebuffer driver for XGI chipsets
>>
>> does the staging tree not require properly formatted git patches ?
>
> "properly formatted" how?
>
> Yes, there are coding style issues in there, that's one of the reasons
> it's in the staging tree :)
>
> Or are you referring to something else?

this guy clearly hasnt set his author field.  there is no proper name
here, just an e-mail address.  looking through the current commits in
the staging tree, i see similar errors, some of which are even in the
s-o-b tag.
-mike
