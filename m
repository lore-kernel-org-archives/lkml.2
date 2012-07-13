Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030601Ab2GMGIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:08:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53429 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2GMGIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:08:32 -0400
Date: Fri, 13 Jul 2012 08:01:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] time: Refactor accumulation of nsecs to secs
Message-ID: <20120713060121.GD18065@gmail.com>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
 <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> +}
> +
> +
> +/**

Stray newline added here as well.

Thanks,

	Ingo
