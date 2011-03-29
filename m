Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1C2EWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:22:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab1C2EWq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:22:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110329040939.GA32764@redhat.com>
References: <20110329040939.GA32764@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 21:22:25 -0700
Message-ID: <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
Subject: Re: vma corruption in today's -git
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 9:09 PM, Dave Jones <davej@redhat.com> wrote:
>
> I ran perf top, and got this ..
>
>  BUG: unable to handle kernel paging request at fffffffffffffff3

Should be fixed by commit 76597cd31470.

Except that was already committed yesterday. When did you pull?

                        Linus
