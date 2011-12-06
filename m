Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1LFHHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:07:18 -0500
Received: from tundra.namei.org ([65.99.196.166]:54198 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LFHHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:07:16 -0500
Date: Tue, 6 Dec 2011 18:07:14 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] __d_path() API change (was Re: [PATCH] Remove use of
 mnt_ns->root and fix a couple of bugs in d_namespace_path)
In-Reply-To: <20111206035838.GD2203@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.2.00.1112061806360.27226@tundra.namei.org>
References: <1323034020-28780-1-git-send-email-john.johansen@canonical.com> <20111204221020.GB2203@ZenIV.linux.org.uk> <20111205032711.GC2203@ZenIV.linux.org.uk> <4EDD7F46.1050907@canonical.com> <20111206035838.GD2203@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Al Viro wrote:

>     the patch survives his testing]
>     
>     Reviewed-by: John Johansen <john.johansen@canonical.com>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>     Cc: stable@vger.kernel.org

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
