Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab1FOTE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:04:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1FOTEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:04:52 -0400
Date: Wed, 15 Jun 2011 21:03:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110615190302.GA16440@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615145527.4016.70157.stgit@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to ask,

On 06/15, Greg Kurz wrote:
>
> The need arises in the LXC community when one wants to send a signal from
> the host (aka. init_pid_ns context) to a container process for which one
> only knows the pid inside the container.

I am just curious, why do you need this?

Oleg.

