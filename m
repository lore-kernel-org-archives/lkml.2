Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1CBUE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:04:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab1CBUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:04:25 -0500
Date: Wed, 2 Mar 2011 12:03:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: x86: kill binutils 2.16.x?
Message-Id: <20110302120339.efd60504.akpm@linux-foundation.org>
In-Reply-To: <4D6E8932.1010405@zytor.com>
References: <4D6E8932.1010405@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 10:15:14 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> binutils 2.16 (and presumably its prereleases, binutils 2.15.9x) appears
> to have more bugs than any other version of binutils released in modern
> history, *before or after*.
> 
> We chronically run into problems because that particular binutils
> version breaks code that works fine elsewhere.
> 
> I would like to know who would suffer from formally discontinuing
> support for that version.  I understand some version of SLES shipped it,
> but I don't know for sure.
> 

I gave up and became a customer of
http://www.kernel.org/pub/tools/crosstool/index_old.shtml
