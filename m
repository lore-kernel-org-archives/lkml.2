Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2EXWkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:40:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34292 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2EXWkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <4FBEB72D.4040905@redhat.com>
References: <4FBE5518.5090705@redhat.com> <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com>
 <4FBEB72D.4040905@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 15:40:17 -0700
X-Google-Sender-Auth: hsQLy5P5QJ8Cg2dTUq8m_zxcSus
Message-ID: <CA+55aFyYQkrtgvG99ZOOhAzoKi8w5rJfRgZQy3Dqs39p1n=FPA@mail.gmail.com>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 3:33 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> The Kconfig default for DVB_FE_CUSTOMISE is 'n'. So, if no DVB bridge is selected,
> nothing will be compiled.

Sadly, it looks like the default for distro kernels is 'y'.

Which means that if you start with a distro kernel config, and then
try to cut it down to match your system, you end up screwed in the
future - all the new hardware will default to on.

At least that's how I noticed it. Very annoying.

                    Linus
