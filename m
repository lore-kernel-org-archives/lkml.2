Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1AYW2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:28:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1AYW2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K5cYYAHRdHyMRj95WYuBB25pUZgrT7RbUkzLuCJVHYbSE39r4JOn1v5Ipc8fH3MNCX
         VdSht54RT9iadIU1fWXbcCafXbytVUy8uXozerytTA9+ssO0d3ZzwYeDyVmLV/2+d3A4
         bHpqjenpvak9ou+w4N4XK3L8SlpuIw6zQRyK0=
Date: Tue, 25 Jan 2011 23:28:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/20] tracing: don't trace the BKL
Message-ID: <20110125222828.GA2532@nowhere>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
 <1295993854-4971-18-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295993854-4971-18-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:17:31PM +0100, Arnd Bergmann wrote:
> No reason to trace it when the last user is gone.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

You could also remove file and line arguments from _(un)lock_kernel
but as the final removal follows, we just don't care.

Tell us if you want that in the tracing tree. But I guess this
should be included in the same set than the rest or?

Thanks!
