Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1BPT7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:59:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab1BPT7d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:59:33 -0500
MIME-Version: 1.0
In-Reply-To: <20110216193700.GA6377@elte.hu>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 11:50:28 -0800
Message-ID: <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 11:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> ( Cc:-ed Linus - he was analyzing a similar looking bug a few days ago on lkml.
>  Mail repeated below. )

Yup, goodie. It does look like it might be exactly the same thing,
except now the offset seems to be 0x1e68 instead of 0x1768.

I'll compile a x86-32 kernel with that config and try to see if I can
find that offset in there..

                      Linus
