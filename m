Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0GETrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:47:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39047 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0GETrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=igszdY6oC8ca+oWhyZl1ORfqrNpB/Xi8sOvAwwZ36lrl9F2M/7fE5XqwMwh/h9Czlw
         fYs4etfXuswC3FM5wnkWePBQqwrepRbWJ0vIR9HrgE8J79p4CMqfTemggVbO9dFAKmD4
         3PnmH69EyMNvfcBrCMQrTefSdNheL4BZ9VxUs=
Date: Mon, 5 Jul 2010 21:48:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Message-ID: <20100705194759.GE5240@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-4-git-send-email-arnd@arndb.de> <20100705192358.GC5240@nowhere> <4C3235C3.7050303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3235C3.7050303@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 12:42:59PM -0700, H. Peter Anvin wrote:
> On 07/05/2010 12:24 PM, Frederic Weisbecker wrote:
> > On Sun, Jul 04, 2010 at 12:15:07AM +0200, Arnd Bergmann wrote:
> >> Handling of autofs ioctl numbers does not need to be generic
> >> and can easily be done directly in autofs itself.
> >>
> >> This also pushes the BKL into autofs and autofs4 ioctl
> >> methods.
> >>
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> Cc: H. Peter Anvin <hpa@zytor.com>
> > 
> > Peter, if you're fine with this version. May I apply it?
> > Unless you have a tree for autofs.
> > 
> > Thanks.
> 
> Ian Kent is the maintainer of autofs4 and patches for autofs4 should go
> through him (or acked by him.)
> 
> autofs 3 is officially unmaintained; I'm more than happy to have you
> push the autofs 3 bits of this patch.


Sure, I can split up the patch and integrate the autofs 3 part, I'll send
the standalone autofs4 version to Ian.

Thanks.

