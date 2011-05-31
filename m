Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab1EaVgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:36:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758482Ab1EaVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110531181650.GA1854@gere.osrc.amd.com>
References: <20110531163022.GA15435@elte.hu> <1306859709.20175.27.camel@Joe-Laptop>
 <20110531181650.GA1854@gere.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Jun 2011 06:35:46 +0900
Message-ID: <BANLkTi=ysOYxxu1_PV3R1BNgjM996A2CKg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
To: Borislav Petkov <bp@amd64.org>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 3:16 AM, Borislav Petkov <bp@amd64.org> wrote:
>
> Crap, there's no fixing this string :)

I tried to fix it up in the merge.  We call these "evil merges" in
git-speak, but I hope the problem was worth doing one ;)

                  Linus
