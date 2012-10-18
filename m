Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2JRT7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:59:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55419 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2JRT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:59:45 -0400
Date: Thu, 18 Oct 2012 23:59:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] print reason for failure in kcmp_test
Message-ID: <20121018195941.GJ8790@moon>
References: <20121018194104.GA15690@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018194104.GA15690@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:41:04PM -0400, Dave Jones wrote:
> I was curious why sys_kcmp wasn't working, which led me to the testcase.
> It turned out I hadn't enabled CHECKPOINT_RESTORE in the kernel I was testing.
> Add a decoding of errno to the testcase to make that obvious.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks Dave!
