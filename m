Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab2EUS3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:29:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61173 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab2EUS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120521182400.GA6043@merkur.ravnborg.org>
References: <20120521.050300.1434374935904126254.davem@davemloft.net>
 <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com> <20120521182400.GA6043@merkur.ravnborg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 11:28:58 -0700
X-Google-Sender-Auth: kEorX9RbaulPlVbjQk00JkNzzUU
Message-ID: <CA+55aFymRE-_1qzCA_n3xYbMseQrZsjJWWX74S3jn5Qyf9Efjw@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:24 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> So the "if NET" part in the select is redundant but not strictly wrong.

It's not redundant.

Try doing a "make ARCH=sparc allnoconfig" without it. It will warn.

I didn't bother looking at *why* it warns, but all other architectures
have the "if NET" part.

                   Linus
