Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab1FUWkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:40:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37716 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab1FUWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AH5YIOqopR5iTdyKhIDNZnvj2/32Y5+T22l2AlaCN2yKseKn3XNCFnUfKIpDwD5xxq
         ncw/KQT+5vGuwVOPEckIAiigyM/fkHfVKika4/FMPMiUD/p1ptdx+t/QO6zFmQpr77FO
         hSeJen4rWP6dobni6V5x6oFiuyjLbbpyejjeo=
MIME-Version: 1.0
In-Reply-To: <20110621151055.0775f17a.sfr@canb.auug.org.au>
References: <20110621151055.0775f17a.sfr@canb.auug.org.au>
Date: Wed, 22 Jun 2011 01:40:48 +0300
Message-ID: <BANLkTimmy0GJMgho4YK62gru6QXGox6Eqg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the trivial and
 net trees
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Tue, Jun 21, 2011 at 8:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmfmac/wl_iw.c between commit e44ba033c565
> ("treewide: remove duplicate includes") from the trivial tree, commit
> 219eb47e6f35 ("net/staging: add needed interrupt.h and hardirq.h
> includes") from the net tree and various commits from the staging tree.
>
> I fixed them up (see below) and can carry the fix as necessary.

This one and all the others look good to me.

Vitaliy
