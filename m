Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0CORlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0CORlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:41:11 -0400
Date: Mon, 15 Mar 2010 18:39:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH 2/2] exec: replace call_usermodehelper_pipe with use of
	umh init function and resolve limit
Message-ID: <20100315173913.GB7976@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315123602.GD16175@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315123602.GD16175@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Neil Horman wrote:
>
> The first patch in this series introduced an init function to the
> call_usermodehelper api so that processes could be customized by caller.
> This patch takes advantage of that fact, by customizing the helper in
> do_coredump to create the pipe and set its core limit to one (for our
> recusrsion check).  This lets us clean up the previous uglyness in the
> usermodehelper internals and factor call_usermodehelper out entirely.
> While I'm at it, we can also modify the helper setup to look for a core
> limit value of 1 rather than zero for our recursion check
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andi Kleen <andi@firstfloor.org>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

