Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2BUALy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:11:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64864 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2BUALw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:11:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.97.196 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <d3bc5132-98b4-485b-b400-5046350b7ccf@email.android.com>
References: <1329781367.25686.45.camel@gandalf.stny.rr.com> <d3bc5132-98b4-485b-b400-5046350b7ccf@email.android.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 16:11:31 -0800
X-Google-Sender-Auth: 1oOTNdE5yn02eNVaYtvKrceTl68
Message-ID: <CA+55aFywfyiLAWgp9ohMokrXFc-q7SLYMZtTunSpC_MO2dut3Q@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Specify a size for the cmp in the
 NMI handler
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 4:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> You can use cmpl here... the segment is only a 16-bit number.  Or use testb $3,...

Yeah. And cmpl is one byte shorter (and the same size as testb).

               Linus
