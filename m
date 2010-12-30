Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0L3U6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 15:58:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58821 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0L3U63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 15:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-3-git-send-email-bigeasy@linutronix.de> <1290807736.32570.143.camel@pasglop>
 <20101128134907.GA30784@www.tglx.de> <20101230082654.GB11721@angua.secretlab.ca>
 <AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Dec 2010 13:58:09 -0700
X-Google-Sender-Auth: 2KLT6nnmmhkexGAGWYlY8cTu1mM
Message-ID: <AANLkTinSr_KYkFNUmWbL2PUzS2Ose7cA5q8xUbLeUr=J@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: Add device tree support
To: Rob Landley <rob@landley.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 1:45 AM, Rob Landley <rob@landley.net> wrote:
> On Thu, Dec 30, 2010 at 2:26 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> What is the boot sequence for the embedded x86 platforms?  Is there
>> still a bootloader?
>
> There's no one embedded setup on any platform, but one of the few
> constants of embedded development is trying to eliminate unnecessary
> requirements.
>
> Just on standard-ish PC hardware I've seen people try to stick Linux in the
> BIOS flash (generally not enough room), I've seen people try to stick
> it as the first stage PXE payload, there's the fun and games with
> kexec of emergency kernels for crash dumps...
>
> If the capability to skip an unnecessary bootloader was available, people
> would use it.

Right, but in all of those cases a boot wrapper provides the same
functionality with better flexability, such as being able to provided
the dtb image(s) at install time instead of compile time.

g.
