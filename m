Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab1EaGBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:01:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1EaGBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IF/U00CBhBn/AgqG4tawNlYOY0WSUDLm0jnq3+74PBU3OKH18mJSaVRCYi7dOFW6Bh
         8klXPoWZNGrr12ErgtYAEFcvqKmI5CbRKYYp6cbrWZdxue7ziCRBsXnw7/lfy0uj6GUJ
         wKlauBmpqOUAdU7aaQlQ0gnMb2uepJC88Usx8=
MIME-Version: 1.0
In-Reply-To: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
Date: Tue, 31 May 2011 16:01:14 +1000
Message-ID: <BANLkTi=AWgZ12M=SCGFkiJfax24TxDP6MQ@mail.gmail.com>
Subject: Re: Linux 3.0-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 11:30 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Yay! Let the bikeshed painting discussions about version numbering
> begin (or at least re-start).

There's a rumour going around you broke module-init-tools.

So this is an ABI break? so can I break all my stuff as well ;-)

Dave.
