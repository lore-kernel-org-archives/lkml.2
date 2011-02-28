Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1B1IRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:17:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38644 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1B1IRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SKlwoI25M8q5HjEbfB1jXas0A4aVsD1BbY7UJnzNAXZCkgoUgpzBUDl+0IF/ULTNlZ
         I+Jppglx3EjCkEEh5FbVGUAzqjS3ZmqDqg2n6ShBMlDNdblznlR3g9Nl+xlD4f5MJB/Y
         ZExFQXC6Hyv9tG6XxxfzQ4S6Y0TJmrJQWt4ZE=
MIME-Version: 1.0
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Date: Mon, 28 Feb 2011 10:17:32 +0200
Message-ID: <AANLkTi=Wpcw0Z6jwicwaU4XB+ijzvgqZe18Lr8ux59YE@mail.gmail.com>
Subject: Re: [PATCH 00/00]Remove one to many n's in a word.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 6:33 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Anyways hope you take this as my appreciation to the kernel, it may not
> be perfect, may be lame, may not be much, but atleast makes me feel good I did
> the good deed of giving...
It's quite OK for the stable drivers, but for staging one in some
cases (patch #6, for example)
the efforts have no logical end. I mean, the style of a function name
is also wrong
and it might be better to fix the whole name. However, it's only my
own opinion, the maintainer
may have their view on this.

-- 
With Best Regards,
Andy Shevchenko
