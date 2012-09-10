Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2IJPnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699Ab2IJPnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:43:45 -0400
Date: Mon, 10 Sep 2012 11:43:37 -0400
From: David Teigland <teigland@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: ccaulfie@redhat.com, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] dlm: check the maximum size of a request from user
Message-ID: <20120910154337.GA1474@redhat.com>
References: <1347200218-3697-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347200218-3697-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 04:16:58PM +0200, Sasha Levin wrote:
> device_write only checks whether the request size is big enough, but it doesn't
> check if the size is too big.
> 
> At that point, it also tries to allocate as much memory as the user has requested
> even if it's too much. This can lead to OOM killer kicking in, or memory corruption
> if (count + 1) overflows.

thanks, pushed to next

