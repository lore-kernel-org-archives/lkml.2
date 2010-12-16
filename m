Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0LPXR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:17:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab0LPXRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <201012161556.07868.bjorn.helgaas@hp.com>
References: <20101216173614.8185.19462.stgit@bob.kio> <20101216173846.8185.82045.stgit@bob.kio>
 <AANLkTindCiEeHDhDJhc9o-iZHvts2d1QnH2CxmDtgb6=@mail.gmail.com> <201012161556.07868.bjorn.helgaas@hp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Dec 2010 15:17:29 -0800
Message-ID: <AANLkTinqSc1nw1W_p4-Fs7F58aP2B23gj-ODj46e0EVw@mail.gmail.com>
Subject: Re: [PATCH 6/9] resources: add arch hook for preventing allocation in
 reserved areas
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 2:56 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> I did find these cases where we have a weak symbol definition in
> the same file as the caller, as well as another version elsewhere,
> so maybe those toolchains are indeed no longer supported?

Ok, so we already depend on it not breaking. I forget which
gcc/binutils version we had trouble at, so I guess we can forget about
this one.

                  Linus
