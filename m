Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2KLNze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:55:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2KLNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:55:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 38/55] ARC: Low level event capture/logging
Date: Mon, 12 Nov 2012 13:55:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-8-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-8-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121355.23947.arnd@arndb.de>
X-Provags-ID: V02:K0:ZEnBdvJ1QaiOibjVPPe2ByoMkshnAJmmFr3tvOwIWuv
 rM/+Wj640h2K6FspmFygWYWgIg5obIpt5yHcq0gtZyfQKexkbH
 EJCzyJ6zFzr8gyFKwUPzd3sZGBObZG5zlrIooFAjL/6mKF7acy
 9cZ5rgxEajBwYxFxmx8IHVylcx+yY9ZTykqc4adDpvjk6QEHI3
 u3atNqqYKFuP2rZV7KVnFJ0iZqQEwT/ZpYQ9oRZ6FZ1gon2t38
 HGqZJDrFGmbTZvhBTObXbKPs432M0NSWq4Q/Z/RIHkRDVyUALS
 38f/Lj6ciW3TLGOPB0GnFKu5GIvzm1uVBmyJ/C5GR/0g9/J32B
 hV+Wi7D/8bLeNbkno5C0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +EXPORT_SYMBOL(take_snap);
> +
> ...
> +EXPORT_SYMBOL(take_snap2);

Where are these functions called?

Shouldn't this all just be part of the perf module?

If not, can you make the exports GPL-only?

	Arnd
