Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2EHTTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:19:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2EHTTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:19:47 -0400
Date: Tue, 8 May 2012 12:19:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, tim.gardner@canonical.com
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
Message-Id: <20120508121946.c20adb87.akpm@linux-foundation.org>
In-Reply-To: <CAK5ve-J9uTJKC01XFTzU34MY4z_8yVRwTUVXP99Czu=oL-mqxQ@mail.gmail.com>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
	<CAK5ve-J9uTJKC01XFTzU34MY4z_8yVRwTUVXP99Czu=oL-mqxQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012 01:45:43 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> Any comments and suggestions about my v9 patchset.

The drivers/leds/ changes look OK to me.
