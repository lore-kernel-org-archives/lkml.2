Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0ISEvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:51:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58063 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0ISEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DmQ5Dmb2EtlO8d9Cl7zfsLp6mb+Z4QIcskmxn2MJjnVr+kBH+a52f9VwaW7k0/67UB
         nbpiaSRjrY7QdFZO1RKDhgzzHwkYCJYy4A2JgJU/+e4QPYB6fpx1eyEoG+BJaAHnbCiH
         EOmYPOzroZnlHeY/mkcG8KkSTVPMXn2b5WqlA=
MIME-Version: 1.0
In-Reply-To: <4C9579A1.5030009@orcon.net.nz>
References: <20100918083846.GA31363@ZenIV.linux.org.uk> <4C9579A1.5030009@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 19 Sep 2010 00:50:34 -0400
Message-ID: <AANLkTimPZ5=FBdffeeDVB0_=no-rQcdEOdZ0OqLXkpss@mail.gmail.com>
Subject: Re: [PATCH 1/4] alpha: belated ERESTART_RESTARTBLOCK race fix
To: Michael Cree <mcree@orcon.net.nz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 10:46 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> On 18/09/10 20:38, Al Viro wrote:
>>
>> same thing as had been done on other targets back in 2003 -
>> move setting ->restart_block.fn into {rt_,}sigreturn().
>>
>> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
>
> For the patch series:
>
> Tested-by: Michael Cree <mcree@orcon.net.nz>
>
> Cheers
> Michael.
>

Thanks for the test.

Al, I've vacuumed your patches and sent them with others in a pull
request to Linus.

Thanks a ton. Anyone who finds and fixes a 14 year-old bug, well, I
owe you a beer.

Thanks!
Matt
