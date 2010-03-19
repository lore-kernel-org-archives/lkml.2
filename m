Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0CSB3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:29:11 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:49001 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0CSB3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:29:09 -0400
X-Greylist: delayed 4687 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 21:29:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nfp4RlOcUSwQ3XHMgT5ltDFBveFgfEtHZ62GZB2HZKBuuCbZOZProd30VjTY3BDfHC
         wXUHd1sHS8DqSHn7HXXv9Yk/WMLFyNoiUfoiPsOtHDCEGLoPcH6i8Yj+kf7kkyghhJWu
         NCcb+zFhOtTnLwy3f/Y2BfD2XCj40rS6hkVZo=
MIME-Version: 1.0
In-Reply-To: <3e8340491003181806t201218acod8ea408d1993cbfc@mail.gmail.com>
References: <21512362.post@talk.nabble.com>
	 <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com>
	 <21512985.post@talk.nabble.com>
	 <3e8340490901162126u109da9cbu7292fddf6d832723@mail.gmail.com>
	 <49f90a801003181710v5e08ccc8jdd26ec899e75bdb9@mail.gmail.com>
	 <3e8340491003181728r766245edo91ecc1db75f3a6df@mail.gmail.com>
	 <49f90a801003181747m5078d9c2y3cc8421203a7b1e6@mail.gmail.com>
	 <3e8340491003181806t201218acod8ea408d1993cbfc@mail.gmail.com>
Date: Thu, 18 Mar 2010 21:29:07 -0400
Message-ID: <49f90a801003181829w63b3e96fp79c015b15b8d535b@mail.gmail.com>
Subject: Re: Kernel vs user memory
From: Siddhartha Chhabra <siddhartha.chhabra@gmail.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 9:06 PM, Bryan Donlan <bdonlan@gmail.com> wrote:

>
> That is correct. The kernel can avoid a PF if it wants to by ensuring
> the page tables are set up properly from the start; and physical
> addresses below a certain value (which varies by architecture) can be
> accessed directly without any setup at all.
>

Thank you for your time, this discussion was really helpful.

Thanks once again
Sid
