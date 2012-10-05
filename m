Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2JEAd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 20:33:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54016 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab2JEAd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 20:33:26 -0400
Date: Thu, 4 Oct 2012 17:33:19 -0700
From: Kees Cook <kees@outflux.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: viro@zeniv.linux.org.uk, keescook@chromium.org, levinsasha928@gmail.com,
        davej@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: prevent use after free in auditing when symlink
 following was denied
Message-ID: <20121005003319.GH9092@outflux.net>
References: <1349395000-12050-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349395000-12050-1-git-send-email-sasha.levin@oracle.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 07:56:40PM -0400, Sasha Levin wrote:
> Commit "fs: add link restriction audit reporting" has added auditing of failed
> attempts to follow symlinks. Unfortunately, the auditing was being done after
> the struct path structure was released earlier.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks for catching that!

Cc: stable@vger.kernel.org
Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook                                            @outflux.net
