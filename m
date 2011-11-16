Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab1KPBli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:41:38 -0500
Received: from tundra.namei.org ([65.99.196.166]:41048 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab1KPBlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:41:36 -0500
Date: Wed, 16 Nov 2011 12:41:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees@outflux.net>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: clarify the purpose of LSMs
In-Reply-To: <20111102002001.GA28092@outflux.net>
Message-ID: <alpine.LRH.2.00.1111161241040.13546@tundra.namei.org>
References: <20111102002001.GA28092@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, Kees Cook wrote:

> Clarify the purpose of the LSM interface with some brief examples and
> pointers to additional documentation.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>     - based on feedback from James Morris, added reference to
>       http://kerneltrap.org/Linux/Documenting_Security_Module_Intent
> 

Applied to
git://selinuxproject.org/~jmorris/linux-security next

-- 
James Morris
<jmorris@namei.org>
