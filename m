Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0LZVPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 16:15:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60416 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0LZVPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 16:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R/Be8+KfEgPlVMxJTn5dfpRX48ohgK1Ai9Hn7GatUeQk9AWK45nawy7D981oaTMjKV
         EoONDReMdtToNrBJ1qNm4jCgbPM9HmFQvalsDCHP7AQUAzxu2h3KvVwy0ZSZp5kAhr5j
         9rAeng8bWZdu90yuZatdVRDCH7aE+YoET1XnQ=
MIME-Version: 1.0
In-Reply-To: <4D1748D4.5050700@gmail.com>
References: <4D1748D4.5050700@gmail.com>
Date: Sun, 26 Dec 2010 22:15:35 +0100
Message-ID: <AANLkTik71N=OJOD5MvvBitUQM4C42-Q8HSrBc8NiBuSc@mail.gmail.com>
Subject: Re: Return value of generic xattr operations
From: Olaf van der Spek <olafvdspek@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 2:53 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Hi,
>
> is it right that generic_setxattr & co. return -EOPNOTSUPP if there is a
> namespace error? I mean, if the user try to set <my own namespace>.foo
> attribute, the return value should be -EINVAL, isn't it? Operation not

Why?
There are multiple errors and only one can be returned.

> supported means that extended attributes are not enabled or not
> implemented by the fs. The man pages are not much clear about this
> point. What do you think?

Olaf
