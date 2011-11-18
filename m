Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1KRERQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:17:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:48976 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab1KRERO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:17:14 -0500
Date: Fri, 18 Nov 2011 15:17:12 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v6 0/3] security: Yama LSM
In-Reply-To: <1319672956-17114-1-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Kees Cook wrote:

> As discussed at the Linux Security Summit, I'm resubmitting this
> code. As an LSM, it has coherent policy around expanding specific DAC
> behaviors. There is no need for it to be a full-blown MAC, since it is
> not intended to be one, but rather to be a simplified expansion to DAC,
> with system-wide knobs. See the specific patches for details...

In principle, Yama can be merged, however there are features with 
unresolved upstream naks:

- Handling symlinks in sticky directories
- The ptrace tracker

These still need to be resolved.




-- 
James Morris
<jmorris@namei.org>
