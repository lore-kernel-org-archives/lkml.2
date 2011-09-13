Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1IMBQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:16:04 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:47661 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1IMBQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:16:02 -0400
MIME-Version: 1.0
In-Reply-To: <1314826019-22330-11-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	<1314826019-22330-11-git-send-email-msalter@redhat.com>
Date: Mon, 12 Sep 2011 18:16:00 -0700
X-Google-Sender-Auth: dvhs4mfapEK7qLPrZJoz7zStYZw
Message-ID: <CANcMJZBxCQFgAsO89X+_SSm02vtseRhY7ozoxik4UMEuJUdDNQ@mail.gmail.com>
Subject: Re: [PATCH 10/24] C6X: time management
From: john stultz <johnstul@us.ibm.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 2:26 PM, Mark Salter <msalter@redhat.com> wrote:
> The C6X architecture includes a 64-bit free running core clock counter which
> is used as the clocksource. The SoCs have a number of 64-bit programmable
> timers. One of these is used as the clockevent timer.
>
> Signed-off-by: Mark Salter <msalter@redhat.com>

Sort of a tangent to this specific patch, but since it came up
recently in the x32 discussion, I wanted to check if you were using a
64bit definition of time_t?

thanks
-john
