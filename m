Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2CSJHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:07:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50055 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab2CSJHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <1331859585-27765-1-git-send-email-john.stultz@linaro.org>
References: <1331859585-27765-1-git-send-email-john.stultz@linaro.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 19 Mar 2012 11:06:56 +0200
Message-ID: <CA+1xoqdmLmqLtzAXnds4amMBT78vvKHk46rkvjA8BiaBTpVtoQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] ntp: Fix leap-second hrtimer livelock
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 2:59 AM, John Stultz <john.stultz@linaro.org> wrote:
> This patch tries to avoid the problem by reverting back to not using
> an hrtimer to inject leapseconds, and instead we handle the leapsecond
> processing in the second_overflow() function.

Looks like the patch fixes the problem here, no other side effects observed.
