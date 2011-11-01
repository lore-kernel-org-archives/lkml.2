Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1KAUp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:45:56 -0400
Received: from tundra.namei.org ([65.99.196.166]:36893 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1KAUpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:45:54 -0400
Date: Wed, 2 Nov 2011 07:45:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v6 0/3] security: Yama LSM
In-Reply-To: <1319672956-17114-1-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.00.1111020735080.11087@tundra.namei.org>
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

Yes, there was a strong consensus (unanimous I believe) at the security 
summit on incorporating the Yama LSM as a container for generally useful 
miscellaneous security hardening features that don't belong elsewhere.

This means that LSM is no longer 'officially' only for access control 
mechanisms.

We probably need to flesh out criteria for inclusion in Yama and document 
it.



- James
-- 
James Morris
<jmorris@namei.org>
