Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0L3Ipq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:45:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57458 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0L3Ipp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:45:45 -0500
MIME-Version: 1.0
X-Originating-IP: [24.27.19.110]
In-Reply-To: <20101230082654.GB11721@angua.secretlab.ca>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	<1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
	<1290807736.32570.143.camel@pasglop>
	<20101128134907.GA30784@www.tglx.de>
	<20101230082654.GB11721@angua.secretlab.ca>
Date: Thu, 30 Dec 2010 02:45:44 -0600
Message-ID: <AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: Add device tree support
From: Rob Landley <rob@landley.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 2:26 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> What is the boot sequence for the embedded x86 platforms?  Is there
> still a bootloader?

There's no one embedded setup on any platform, but one of the few
constants of embedded development is trying to eliminate unnecessary
requirements.

Just on standard-ish PC hardware I've seen people try to stick Linux in the
BIOS flash (generally not enough room), I've seen people try to stick
it as the first stage PXE payload, there's the fun and games with
kexec of emergency kernels for crash dumps...

If the capability to skip an unnecessary bootloader was available, people
would use it.

Rob
