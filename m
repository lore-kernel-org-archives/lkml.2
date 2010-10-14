Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0JNVDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:03:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35005 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0JNVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=OCLCZUW6YdIR7HjH5d4Deim7T48k3DqLQKmhV6txAjtZim4Q+j4h/XXp+TATaAchwW
         FSiaWI9XBoHp6gjhtmBu+a4OzoSKHfAjs9ehgGP8b8jLbDRU9mjZRsY5pvUsw68LbOZA
         f7cEyEfzXjB+PxIVoeE2+TWWn4MtHjcRlWa9g=
MIME-Version: 1.0
In-Reply-To: <AANLkTim2_St6Z9dLHaFxfcufM7gf=B_9ouYZWCb5M9KL@mail.gmail.com>
References: <AANLkTim2_St6Z9dLHaFxfcufM7gf=B_9ouYZWCb5M9KL@mail.gmail.com>
Date: Thu, 14 Oct 2010 14:03:44 -0700
Message-ID: <AANLkTineviAtWueibRfz7cE79334UQpgfM0sJaUsAemz@mail.gmail.com>
Subject: Re: commit 0eead9ab breaks ia64 build
From: Tony Luck <tony.luck@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 1:58 PM, Tony Luck <tony.luck@gmail.com> wrote:
> I guess I have to start juggling some #includes ... anyone else have problems?

Just adding

#include <asm/uaccess,h>

to include/linux/coredump.h

seems to fix it for me.

-Tony
