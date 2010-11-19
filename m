Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0KSTns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:43:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38380 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab0KSTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ttFt6BBeUIKaqxsOM8pGfhisyeDuA8SJY3OHSzDGSpyv296Ultkw6pbQ8iFiNNAmns
         negHLYc3koyQKPVvhzbXJAyIBnoGMjsFllrL7+2KzKzFLO4PTQ7o1lbbie/Jz04FB0ae
         lY3B/BHdnXXC//y7fLX9Jm+QgIpeEvm4MxkVg=
MIME-Version: 1.0
In-Reply-To: <20101116140900.039761100@kernel.dk>
References: <20101116140900.039761100@kernel.dk>
Date: Fri, 19 Nov 2010 11:43:45 -0800
X-Google-Sender-Auth: Tk8c6iHOXBFgVTD2YrHPjEMWZNg
Message-ID: <AANLkTikzWK-cedm7QPK-jhi=xJRAwufbgxjPEdQxx=VQ@mail.gmail.com>
Subject: Re: [patch 00/28] [rfc] dcache scaling part 1
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 6:09 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> There are 3 main parts to dcache scaling. This one primarily adds new locks
> to take over dcache_lock, and some pre/post prep and streamlining patches.
>
> The second implements fine grained locking, and is rather trivial after
> part 1.
>
> The third implements rcu-walk. rcu-walk depends on the first part, because it
> relies on using d_lock to protect the state of the dentry (when converting from
> rcu-walk to refcounted walk). Without the fine grained locing, we'd need to use
> dcache_lock for that, which would be a step backwards to put into path walking
> again.

Reviewed-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
