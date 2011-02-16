Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1BPRwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:52:23 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60452 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1BPRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:52:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VNvMBPVyfTMr7letTEAtW5ANFS/4sbXG/UoDy6ykmmoA8z+Q3l18ctAIz59KJWCyrk
         kwc/P+NKLYTfew1Fm/Snpc+b6FXHxUCA8ZCagmt0cDV9ELrpVL+pGjMT0k++XlIcfw36
         ohKQdUYa3eH9M+kluaGaARS2NlzgxLuj91GA8=
MIME-Version: 1.0
In-Reply-To: <1297838092-22989-3-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
	<1297838092-22989-3-git-send-email-johnstul@us.ibm.com>
Date: Wed, 16 Feb 2011 09:52:20 -0800
Message-ID: <AANLkTinEj8nacqiyEjYKYy4ULyQJ0mzSyq74ofdWLS-c@mail.gmail.com>
Subject: Re: [PATCH 2/6] ia64: convert to clocksource_register_hz/khz
From: Tony Luck <tony.luck@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 10:34 PM, John Stultz <johnstul@us.ibm.com> wrote:
> This converts the ia64 clocksources to use clocksource_register_hz/khz
>
> This is untested, so any assistance in testing would be appreciated!

Works OK on my system (using itc clock source). I don't have cyclone,
sn2 or hpet systems to check the other three parts of this change.

Tested-by: Tony Luck <tony.luck@intel.com> [clocksource_itc path]
