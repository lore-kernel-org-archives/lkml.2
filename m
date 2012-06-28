Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2F1QNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:13:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50171 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2F1QNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:13:35 -0400
MIME-Version: 1.0
In-Reply-To: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
References: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 18:13:34 +0200
Message-ID: <CACRpkdamJ1+YpJmkihy3M79wDmHFrbyJ9n9WjG98rOip8c2j2w@mail.gmail.com>
Subject: Re: [PATCH 00/15][RFC] Android ETM driver changes
From: Linus Walleij <linus.walleij@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 4:01 AM, John Stultz <john.stultz@linaro.org> wrote:

> The Android kernel tree has a number of changes to the ETM driver.
> Arve sent the first 9 of these to the list over a year ago and
> got very little response.
>
> I didn't want these to get lost, so I pinged Alexander about
> these privately and he stated that he wasn't actively
> maintaining the driver, but after skimming the entire set
> acked the series and suggested I send it on to Russel for
> review and possible inclusion.
>
> So here they are. Please let me know if there are any
> objections to merging these, or if further changes are
> needed.

I finally reviewed them, sorry for the lag.

In all this is very useful stuff, maybe people just don't realize how
useful it really is. I suggest you to write a small doc in
Documentation/arm/etm.txt on how to get started etc.

Thanks for your efforts!

Yours,
Linus Walleij
