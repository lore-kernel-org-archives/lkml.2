Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0EQCfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:35:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47844 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0EQCfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HpN4UFNaTh2qW/o/ihmXaRA5cMpUJYkKew6pmOWhmXiuLsOVUK0KzK+PRreLgNOKjf
         rHnFPv+8YEafMMZTJyggw/iP+aGi5JapgPTdcck9tTV8heJ1yx9kAb+IrngTwNgzHCcJ
         qr1ARduBRCEdLPkvxlzR+cc8eAHZgzq6t60pg=
Date: Mon, 17 May 2010 04:35:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] smbfs: BKL ioctl pushdown
Message-ID: <20100517023508.GG22299@nowhere>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <1273065339-21669-6-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273065339-21669-6-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:15:38PM +0200, John Kacur wrote:
> Convert smb_ioctl to an unlocked ioctl and push down the bkl into it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>


In fact this one doesn't apply, not a single hunk.

Against which tree have you made this patch?

