Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1HNQVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab1HNQVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:21:04 -0400
Date: Sun, 14 Aug 2011 18:17:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, bonbons@linux-vserver.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110814161707.GB30846@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Daniel Lezcano wrote:
>
> In the case of a VPS, when we shutdown/halt/reboot the container, the
> reboot utility will invoke the sys_reboot syscall which has the bad
> effect to reboot the host.

Stupid question. Can't sys_reboot() simply kill init (and thus the whole
pid_ns) in this case?

Oleg.

