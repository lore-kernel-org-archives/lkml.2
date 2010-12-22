Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0LVX0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:26:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0LVX0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:26:23 -0500
Date: Thu, 23 Dec 2010 00:26:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
In-Reply-To: <20101222.115721.39176015.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1012230023490.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012172310400.16569@pobox.suse.cz> <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz> <20101222.115721.39176015.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, David Miller wrote:

> > Besides that, any comments on this, please?
> 
> It's in my backlog, patience is a virtue.

Please just disregard it, it's not needed with newer kernels. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
