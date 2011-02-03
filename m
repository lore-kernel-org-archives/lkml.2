Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1BCKCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:02:16 -0500
Received: from ozlabs.org ([203.10.76.45]:48863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab1BCKCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:02:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Date: Thu, 3 Feb 2011 20:32:08 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
References: <4D41E86D.8060205@free.fr> <201102031230.13759.rusty@rustcorp.com.au> <3ba4a711-ac8b-46aa-b585-51c8b9881c8c@email.android.com>
In-Reply-To: <3ba4a711-ac8b-46aa-b585-51c8b9881c8c@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102032032.08848.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 01:05:44 pm H. Peter Anvin wrote:
> Can we completely kill the "don't reload segments" flag, then?

We can as far as *I* am concerned, but of course it's a separate issue...

Thanks,
Rusty.
