Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0JROGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:06:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54747 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab0JROGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xyjkK5zUdyymbHaj6dhsFizhglVMfOdwpy9jkn7ITHrA/E0HxcnikPwuQuHJV6wZaC
         PFn+1VSaSJ7OuBebThnoarwuy+NVKqj/JfU7Bgj6ceBETg2jzmcKjv4tdF2eeN69Ftyv
         4eN2k8sr/TCjV4zJFDuRf/7yDhLSSy/BoHi6Y=
Subject: Re: [PATCH 0/6] Results of my work on memorystick subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <451805.21484.qm@web37607.mail.mud.yahoo.com>
References: <451805.21484.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 16:06:19 +0200
Message-ID: <1287410779.20229.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 00:05 -0700, Alex Dubov wrote:
> --- On Sun, 17/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > > 
> > > Here is a result of lot of work I did improving the
> > memorystick
> > > subsystem and its drivers.
> > Comments?
> > Flames?
> > Suggestions?
> > 
> 
> My opinion is, that in the current form your patches are completely
> unworkable.
> 
> I suggest a following approach, consisting of 3 clearly separated steps:
> 
> Step 1 - a set of functional patches to jmicron driver.
> Step 2 - a set of functional patches to mspro driver.
> Step 3 - common code elimination (the whole thing is not that large, it
> can tolerate some code duplication).
> 
> When we done with this, we can discuss whatever cosmetic changes you want
> to do (moving stuff around and , possibly, renaming, which I don't see as
> necessary at all).
Alex,
In jmicron driver I did move functions around and renamed them.
I am not against doing that in separate patch.

But for mspro driver, it would be really hard for me to split it.
I have rewritten a lot of code there.
Can't we just review the end result instead of the patch?

To split the patches, I pretty much need to rewrite the whole thing once
gain.
I don't want to do that.

Best regards,
	Maxim Levitsky

