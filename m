Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2EXPou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:44:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64251 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2EXPot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <4FBE5456.5020408@zytor.com>
References: <20120523113432.GA12142@gmail.com> <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
 <4FBD1AC8.7020602@zytor.com> <20120523174844.GA3373@gmail.com>
 <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com> <4FBE5456.5020408@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 08:44:27 -0700
X-Google-Sender-Auth: iN-jd5JMER9hVISD5XOqXSljWi4
Message-ID: <CA+55aFyriUQCdEpa_YPBk-JvKAN26xC=MxWb3kO=xSkEou27dA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 8:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Just for clarification - do you want the patch reverted?  My reading of
> what you wrote (as well as of the patch) is that it was an unnecessary
> (redundant) patch, but Ingo is worried that you are saying it is incorrect.

It's not technically incorrect, it was just unnecessary.

                   Linus
