Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2JEIv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:51:58 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63809 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2JEIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:51:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
Date: Fri, 5 Oct 2012 09:51:55 +0100
Message-ID: <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
Subject: interrupt context
From: Iain Fraser <iainkfraser@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I understand the interrupts and softirq's run in interrupt context (
as opposed to process context ). But what I
don't understand is why you cannot sleep in interrupt context?

What I have read it states that it doesn't have a process to schedule
out. But interrupts use the interrupted processes
kernel stack just like a syscall. So surely it is possible to sleep
using that stack. Understandably It would be unfair on the process
that blocked through no fault of its own.

Also if you are not allowed to sleep / schedule during interrupt
context. Then how does the system timer pre-empt processes by
calling schedule?

I understand there are many reasons why you shouldn't: irq lines being
disabled, quick completion, etc. But I don't understand
why you cannot.

Thanks for the help
Iain
