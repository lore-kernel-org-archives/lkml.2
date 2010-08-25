Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0HYAoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:44:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61540 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0HYAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IFIcrat+EWxsusgCdM7XvcQqwZUGRzkFlXOtJ72bpzFywe+miBnPg9hHYOVtUHCQaR
         AooE9oQwz0DY7BhgUIsMLCuKrDFazCMfjWDOWpLQ/bbDn58lVE5xTihNWTdyAF4E+t3h
         jo4BbeiTX77u7KMRgJlpAq7cz5p2fXKkw7cZ8=
MIME-Version: 1.0
In-Reply-To: <1282696543.25208.29.camel@Joe-Laptop>
References: <1282692902-2981-1-git-send-email-xiaosuo@gmail.com>
 <1282694621.25208.19.camel@Joe-Laptop> <AANLkTinfjGB_1CaWNQHynFWK5Tki9BJCW3oeOaY68py9@mail.gmail.com>
 <1282696543.25208.29.camel@Joe-Laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 25 Aug 2010 08:44:31 +0800
Message-ID: <AANLkTimOUS6Zn2OmT=tivBgZiH+HzfzXOAEHKundeyXp@mail.gmail.com>
Subject: Re: [PATCH] lib: fix scnprintf() if @size is == 0
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 8:35 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2010-08-25 at 08:10 +0800, Changli Gao wrote:
>> On Wed, Aug 25, 2010 at 8:03 AM, Joe Perches <joe@perches.com> wrote:
>> > Isn't simpler to check size at the beginning of the function?
>> It is a rare case, so don't slow down the normal users.
>
> That's fine, but I don't like blinking that much
> when I read code.
>

"? :" isn't friendly. OK, I'll update my patch. Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
