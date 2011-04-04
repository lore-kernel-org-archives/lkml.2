Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1DDJ22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:28:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64333 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1DDJ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:28:27 -0400
Message-ID: <4D998EDD.1080404@ru.mvista.com>
Date: Mon, 04 Apr 2011 13:26:53 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: Fix Kconfig unmet dependencies for Microblaze EHCI
References: <1301908812-8119-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1301908812-8119-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-04-2011 13:20, Michal Simek wrote:

> Disable USB_ARCH_HAS_EHCI in arch Kconfig and enable it in usb Kconfig

> Warning log:
> warning: (LOCKDEP&&  FAULT_INJECTION_STACKTRACE_FILTER&&  LATENCYTOP&&  FUNCTION_TRACER&&
> KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL&&
> (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) ||
> ARCH_WANT_FRAME_POINTERS)

    Hm, what this has to do with USB_ARCH_HAS_EHCI?

> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: linux-usb@vger.kernel.org

WBR, Sergei
