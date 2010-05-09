Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0EITIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 15:08:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0EITIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 15:08:34 -0400
Date: Sun, 9 May 2010 21:06:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mathias Krause <Mathias.Krause@secunet.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic on kill(0, SIGTERM) with PGID == 0
Message-ID: <20100509190622.GA12719@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100509184510.GA15219@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 05/09, Oleg Nesterov wrote:
>
> We should also change INIT_SIGHAND, but _hopefully_ this is enough
> to fix the crash.

Also. I strongly believe we should change INIT_STRUCT_PID.tasks, it
should be hlist_empty(). But this needs another discussion.

Oleg.

