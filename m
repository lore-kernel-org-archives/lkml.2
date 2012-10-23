Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456Ab2JWU64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:58:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:50337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132Ab2JWU6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:58:53 -0400
Message-ID: <1351025923.14292.1.camel@clam>
Subject: Re: [PATCH 024/193] arch/powerpc/platforms/ps3: remove
 CONFIG_EXPERIMENTAL
From: Geoff Levand <geoff@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Date: Tue, 23 Oct 2012 13:58:43 -0700
In-Reply-To: <1351022666-6960-25-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-25-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 13:01 -0700, Kees Cook wrote:
>  
> -	depends on PPC_PS3 && EXPERIMENTAL
> +	depends on PPC_PS3

Looks OK.

Acked-by: Geoff Levand <geoff@infradead.org>


