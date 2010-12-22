Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0LVX1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:27:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43938
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab0LVX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:27:14 -0500
Date: Wed, 22 Dec 2010 15:27:43 -0800 (PST)
Message-Id: <20101222.152743.28800942.davem@davemloft.net>
To: jkosina@suse.cz
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1012230023490.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
	<20101222.115721.39176015.davem@davemloft.net>
	<alpine.LNX.2.00.1012230023490.16569@pobox.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 23 Dec 2010 00:26:21 +0100 (CET)

> On Wed, 22 Dec 2010, David Miller wrote:
> 
>> > Besides that, any comments on this, please?
>> 
>> It's in my backlog, patience is a virtue.
> 
> Please just disregard it, it's not needed with newer kernels. Thanks,

Was it indeed fixed by commit 86bcebafc5e7f5?
