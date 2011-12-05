Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab1LEU4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:56:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab1LEU4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:56:53 -0500
Date: Mon, 5 Dec 2011 21:51:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 0/1][V3] Handle reboot in a child pid namespace
Message-ID: <20111205205137.GA7916@redhat.com>
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr> <20111204212756.GB16362@khazad-dum.debian.net> <4EDBFD67.1040009@free.fr> <4EDD2E5C.1050107@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD2E5C.1050107@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Daniel Lezcano wrote:
>
> On 12/05/2011 12:08 AM, Daniel Lezcano wrote:
> > On 12/04/2011 10:27 PM, Henrique de Moraes Holschuh wrote:
> >> On Sun, 04 Dec 2011, Daniel Lezcano wrote:
> >>>  * V3
> >>>    - removed lock and serialization of pid_ns_reboot
> >>>  * V2
> >>>    - added a lock for the pid namespace to prevent racy call
> >>>      to the 'reboot' syscall
> >>>    - Moved 'reboot' command assigned in zap_pid_ns_processes
> >>>      instead of wait_task_zombie
> >>>    - added tasklist lock around force_sig
> >>>    - added do_exit in pid_ns_reboot
> >>>    - used task_active_pid_ns instead of declaring a new variable in sys_reboot
> >>>    - moved code up before POWER_OFF changed to HALT in sys_reboot
>
> Oleg ? Are you fine with this patch ?

I already sent my reviwed-by ;)

Oleg.

