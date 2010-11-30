Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0K3NPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:15:35 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48347 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0K3NPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:15:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fvgGbo3QGM1TrLKz41WyTZYmBTUV5++O9HuyMYfWnjnT5TRZjktYMzfiEnk+FDk4am
         CsnCRh7JBCa6qkZ75ae4MSN/MYLm/5cK2oH7MKLoYnbdYNKuSW2HbJVYMuXR5Mk19na/
         2iKcHxXkrbURHfN6m3W/Qb4kewtDL4bmmrBq4=
Date: Tue, 30 Nov 2010 16:15:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, yinghai@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] lockup detector:  Compile fixes from removing the
	old x86 nmi watchdog
Message-ID: <20101130131522.GB19575@lenovo>
References: <1291068437-5331-1-git-send-email-dzickus@redhat.com> <1291068437-5331-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291068437-5331-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:07:16PM -0500, Don Zickus wrote:
> My patch that removed the old x86 nmi watchdog broke other arches.  This
> change reverts a piece of that patch and puts the change in the correct spot.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/apic/hw_nmi.c |    9 ++++++++-
>  include/linux/nmi.h           |    4 +++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 

Looks good to me, thanks Don!
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
