Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1CBUym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:54:42 -0500
Received: from www.tglx.de ([62.245.132.106]:54485 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab1CBUyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:54:41 -0500
Date: Wed, 2 Mar 2011 21:54:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: RFC: x86: kill binutils 2.16.x?
In-Reply-To: <4D6E8932.1010405@zytor.com>
Message-ID: <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
References: <4D6E8932.1010405@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, H. Peter Anvin wrote:

> binutils 2.16 (and presumably its prereleases, binutils 2.15.9x) appears
> to have more bugs than any other version of binutils released in modern
> history, *before or after*.
> 
> We chronically run into problems because that particular binutils
> version breaks code that works fine elsewhere.

Please lets get rid of known to be broken shite instead of trying to
work around it for no good reasons. How old is that crap again ?

> I would like to know who would suffer from formally discontinuing
> support for that version.  I understand some version of SLES shipped it,
> but I don't know for sure.

You missed to mention that akpm insists on using them :)

Thanks,

	tglx
