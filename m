Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2AJNad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 08:30:33 -0500
Received: from tundra.namei.org ([65.99.196.166]:60897 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab2AJNab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 08:30:31 -0500
Date: Wed, 11 Jan 2012 00:30:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] audit: no leading space in audit_log_d_path prefix
In-Reply-To: <20120106220710.GA20444@www.outflux.net>
Message-ID: <alpine.LRH.2.00.1201110029580.31733@tundra.namei.org>
References: <20120106220710.GA20444@www.outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012, Kees Cook wrote:

> audit_log_d_path() injects an additional space before the prefix,
> which serves no purpose and doesn't mix well with other audit_log*()
> functions that do not sneak extra characters into the log.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: James Morris <jmorris@namei.org>

