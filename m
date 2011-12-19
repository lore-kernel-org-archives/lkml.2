Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1LSWiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:38:23 -0500
Received: from tundra.namei.org ([65.99.196.166]:50977 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1LSWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:38:20 -0500
Date: Tue, 20 Dec 2011 09:38:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security: update security_file_mmap() docs
In-Reply-To: <20111219193256.GA9709@www.outflux.net>
Message-ID: <alpine.LRH.2.00.1112200937510.31315@tundra.namei.org>
References: <20111219193256.GA9709@www.outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Kees Cook wrote:

> This documents the fields added to security_file_mmap() that were
> introduced in ed0321895182ffb6ecf210e066d87911b270d587.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Applied to
git://selinuxproject.org/~jmorris/linux-security next

-- 
James Morris
<jmorris@namei.org>
