Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab1LEVQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:16:33 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:34475 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab1LEVQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:16:32 -0500
Message-ID: <4EDD349B.2030806@free.fr>
Date: Mon, 05 Dec 2011 22:16:11 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][V3] Add reboot_pid_ns to handle the reboot syscall
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr> <1323030290-22216-2-git-send-email-daniel.lezcano@free.fr> <20111205204238.GA7422@redhat.com>
In-Reply-To: <20111205204238.GA7422@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 09:42 PM, Oleg Nesterov wrote:
> On 12/04, Daniel Lezcano wrote:
>> This patch propose to store the reboot value in the 16 upper bits of the
>> exit code from the processes belonging to a pid namespace which has
>> rebooted. When the reboot syscall is called and we are not in the initial
>> pid namespace, we kill the pid namespace.
>>
>> By this way the parent process of the child pid namespace to know if
>> it rebooted or not and take the right decision.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> ---
>>  include/linux/pid_namespace.h |    8 +++++++-
>>  kernel/pid_namespace.c        |   33 +++++++++++++++++++++++++++++++++
>>  kernel/sys.c                  |    3 +++
>>  3 files changed, 43 insertions(+), 1 deletions(-)
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks like our emails crossed by the wire :)
Thanks again Oleg for your comments and your help.

  -- Daniel
