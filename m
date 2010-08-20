Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0HTRKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:10:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab0HTRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:10:31 -0400
MIME-Version: 1.0
In-Reply-To: <201008180307.42504.rjw@sisk.pl>
References: <201008172206.14349.rjw@sisk.pl> <201008180307.42504.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 10:09:35 -0700
Message-ID: <AANLkTim6+4DVX8FgLEcFgq-afjJNouKE9qOe_xzsxFM_@mail.gmail.com>
Subject: Re: 2.6.36-rc1: Doesn't boot on an AMD-based machine
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 6:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> It doesn't revert cleanly so appended is the revert patch I used for the
> verification if this commit is really responsible for the boot failure.

Hans, Peter? What's the status of this? Should I just take the revert
from Rafael? Ping?

                             Linus
