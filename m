Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2BXMWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:22:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52965 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2BXMWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:22:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.204.130.130 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224114751.GA9510@x1.osrc.amd.com>
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
	<20120224114751.GA9510@x1.osrc.amd.com>
Date: Fri, 24 Feb 2012 08:22:05 -0400
Message-ID: <CAELBVzDZjgihsPMqcmM4pU2BBq6stzmGoHR1LuunqtxHv9vYog@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
From: Kevin Winchester <kjwinchester@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Kevin Winchester <kjwinchester@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 February 2012 07:47, Borislav Petkov <bp@alien8.de> wrote:
>
> Just a hint for the future: when you're sending multiple versions of
> a patchset, it would be really helpful to have changelog in the 0/n
> message so that the reviewer can know what happened in each version.
> I.e.,
>
> v4:
>        Rediff changes against -rc4
>
> v3:
>        Small cleanups, integrate comments.
>
> etc.
>
> Otherwise, we have to go look at the older patches and compare what
> changed.
>

Yes, of course, I'm sorry.  I've been reading LKML for years...You
would think that when I finally get the chance to contribute I would
have learned something by this time.

-- 
Kevin Winchester
