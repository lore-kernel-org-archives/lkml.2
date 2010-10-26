Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab0JZXHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 19:07:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57356 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab0JZXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 19:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FBXWpfmEn8I5VPffsI1CqtVRt8qRJ+NDEd5p2cFbKsBuMT1Bs8jgIBDzGsgImO7JA7
         aRd0EWnu1TxqWywY2ndLI+w6MTyfHe/OzRdECz+6eyF6Z4ifu+c4JBwTUZyTeYIscXG0
         HiscCI85E4+6NkWONE9H5zJt8KZcw9ZwttFs8=
Subject: Re: memstick: Alternative approach to proposed fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1288133739.15918.3.camel@maxim-laptop>
References: <1288114871-805-1-git-send-email-oakad@yahoo.com>
	 <1288133739.15918.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 01:07:08 +0200
Message-ID: <1288134428.15918.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 00:55 +0200, Maxim Levitsky wrote:
> On Wed, 2010-10-27 at 04:41 +1100, Alex Dubov wrote:
> > As I was not able to convince myself that profound changes proposed by Maxim
> > are really necessary, I propose to follow a much milder path with this update
> > round (as I outlined in my previous emails).
> It is really sad to see that patchset.
> 
> 
> > 
> > In this small patchset, I fix a couple of small omissions as well as introduce
> > support for "extended command" MSPro transfer method (currently enabled for
> > JMicron, but I'll clear the TI host for this functionality soon). I expect the
> > current solution to scale trivially for HG and XC transfer methods (I don't
> > have the spec for the later yet).
> Indeed small.
> All the changes in this patchset are really minor and optional.
> I could have dropped them.
> 
> 
> I did much more that that.
> I made the memstick code readable so not only you could understand it
> I also wrote ms_block.c while adding common support.
> I made your code use that support.
> 
> It is really sad that you are doing that.
To futher add to that you are just resending my patch #7,
which is just a minor bugfix, and add evem more complexity to mspro when
you add CMDEX.
Why you made it host dependant?, could I ask.

To be honest the ms subsystem is one of most obscure places I have ever
seen.
It took me much more time to write the driver that what it took me to
write xD driver.

Alex, I really really hope you will accept my work.


Best regards,
	Maxim Levitsky

