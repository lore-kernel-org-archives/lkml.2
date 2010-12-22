Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0LVXdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:33:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:37652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0LVXde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:33:34 -0500
Date: Thu, 23 Dec 2010 00:33:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
In-Reply-To: <20101222.152743.28800942.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1012230029410.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz> <20101222.115721.39176015.davem@davemloft.net> <alpine.LNX.2.00.1012230023490.16569@pobox.suse.cz> <20101222.152743.28800942.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, David Miller wrote:

> >> > Besides that, any comments on this, please?
> >> 
> >> It's in my backlog, patience is a virtue.
> > 
> > Please just disregard it, it's not needed with newer kernels. Thanks,
> 
> Was it indeed fixed by commit 86bcebafc5e7f5?

Yes, exactly. It just wasn't obvious enough when looking at the code 
(hence my followup patch which hopefully makes the code more readable on 
a first sight).

Thanks and sorry for the noise.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
