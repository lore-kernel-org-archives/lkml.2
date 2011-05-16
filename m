Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1EPL61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:58:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1EPL60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:58:26 -0400
Date: Mon, 16 May 2011 13:56:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 1/9] job control: reorganize wait_task_stopped()
Message-ID: <20110516115637.GA4898@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305301580-9924-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Tejun Heo wrote:
>
> wait_task_stopped() tested task_stopped_code() without acquiring
> siglock and, if stop condition existed, called wait_task_stopped() and
> directly returned the result.  This patch moves the initial
> task_stopped_code() testing into wait_task_stopped() and make
> wait_consider_task() fall through to wait_task_continue() on 0 return.

FYI, I already applied this one.

Oleg.

