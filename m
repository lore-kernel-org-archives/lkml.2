Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749Ab0HNRcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682Ab0HNRcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:32:05 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikNTZSqZ-sa0uGY0FnjDnOziu4qR8fEitD2TPQc@mail.gmail.com>
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
 <AANLkTik0gSCA4YAH5VAfmW+a4d5R_nybgLiXa_koWn48@mail.gmail.com> <AANLkTikNTZSqZ-sa0uGY0FnjDnOziu4qR8fEitD2TPQc@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Aug 2010 10:31:11 -0700
Message-ID: <AANLkTi=TNsb_JaP0_us8C0XQwRK3qaUdviA-YxcwT223@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
To: sedat.dilek@gmail.com
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        penberg@kernel.org, arthur@psw.ro, wylda@volny.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 10:27 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
>
> Only to clarify, your new single patch replaces...???
>
> mm: fix missing page table unmap for stack guard page failure case
> mm: keep a guard page below a grow-down stack segment

No, not replaces. It goes on top of them.

                   Linus
