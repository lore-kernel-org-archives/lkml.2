Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2J1B6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 21:58:49 -0400
Received: from spey.erg.abdn.ac.uk ([139.133.204.173]:44715 "EHLO
	spey.erg.abdn.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2J1B6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 21:58:48 -0400
X-Greylist: delayed 2107 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2012 21:58:48 EDT
Date: Sat, 27 Oct 2012 19:23:32 -0600
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 163/193] net/dccp/ccids: remove CONFIG_EXPERIMENTAL
Message-ID: <20121027192332.695d2718@liptov.cs.ualberta.ca>
In-Reply-To: <1351022666-6960-164-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-164-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 13:03:56 -0700
Kees Cook <keescook@chromium.org> wrote:

> From: Kees Cook <keescook@chromium.org>
> To: linux-kernel@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>, Gerrit Renker <gerrit@erg.abdn.ac.uk>, "David S. Miller" <davem@davemloft.net>
> Subject: [PATCH 163/193] net/dccp/ccids: remove CONFIG_EXPERIMENTAL
> Date: Tue, 23 Oct 2012 13:03:56 -0700
> X-Mailer: git-send-email 1.7.9.5
> 
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Gerrit Renker <gerrit@erg.abdn.ac.uk>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
