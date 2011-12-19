Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1LSW3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:29:22 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38186 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1LSW3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:29:20 -0500
Date: Mon, 19 Dec 2011 14:22:40 -0800
From: Kees Cook <kees@ubuntu.com>
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
Message-ID: <20111219222240.GH12321@outflux.net>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org>
 <1324017197-3292-3-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
 <20111219194136.GG12321@outflux.net>
 <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
Organization: Ubuntu
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Tue, Dec 20, 2011 at 07:52:34AM +1100, James Morris wrote:
> We should not see YAMA-specific code in the core kernel.  However you do 
> it, the above should happen in LSM.

Okay, I've removed the pid-ns logic for now. Vasiliy and I can readdress
this at a later time.

Thanks,

-Kees

-- 
Kees Cook
