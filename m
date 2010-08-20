Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0HTRZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:25:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543Ab0HTRZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:25:23 -0400
MIME-Version: 1.0
In-Reply-To: <4C6EB823.1070300@zytor.com>
References: <201008172206.14349.rjw@sisk.pl> <201008180307.42504.rjw@sisk.pl>
 <AANLkTim6+4DVX8FgLEcFgq-afjJNouKE9qOe_xzsxFM_@mail.gmail.com> <4C6EB823.1070300@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 10:24:32 -0700
Message-ID: <AANLkTikwPXL+i0MJSMu5Hw1KLrG=G+BZoatE4QEsngnT@mail.gmail.com>
Subject: Re: 2.6.36-rc1: Doesn't boot on an AMD-based machine
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:15 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I have a fix from Hans queued up in x86/urgent and it will be in the
> next push of the fixes queue, which I am planning to send you today.
>
> http://git.kernel.org/tip/07a7795ca2e6e66d00b184efb46bd0e23d90d3fe

Rafael, can you confirm that that fixes it?

                            Linus
