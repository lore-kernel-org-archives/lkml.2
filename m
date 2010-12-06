Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0LFQPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:15:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab0LFQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:15:35 -0500
MIME-Version: 1.0
In-Reply-To: <1291608346.9376.7.camel@perseus>
References: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
 <AANLkTinaxtTZzWymJfXv2=HBgya2MJ3m21myjMZQ_rxT@mail.gmail.com> <1291608346.9376.7.camel@perseus>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Dec 2010 08:15:13 -0800
Message-ID: <AANLkTikQi9K8v5wqfCh3Ka-h0+2cNpd7kPx+r_-nDG8d@mail.gmail.com>
Subject: Re: [PATCH] autofs4 - remove ioctl mutex
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        autofs mailing list <autofs@linux.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 8:05 PM, Ian Kent <raven@themaw.net> wrote:
>
> Would you like me to re-send after asking those concerned if I can add
> their sign-off, and adding mine of course?

Yes, please re-send with the proper sign-offs. Based on the email that
_should_ just be yours (since there was no other author listed), but
if it came to you from somebody else, please make sure you have their
sign-off too and list them as the original author.

                  Linus
