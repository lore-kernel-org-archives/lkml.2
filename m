Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1CCBGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:06:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46115
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab1CCBGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:06:07 -0500
Date: Wed, 02 Mar 2011 17:06:44 -0800 (PST)
Message-Id: <20110302.170644.58413369.davem@davemloft.net>
To: lucian.grijincu@gmail.com
Cc: adobriyan@gmail.com, ebiederm@xmission.com, tavi@cs.pub.ro,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC v1: sysctl: add sysctl header cookie, share tables between
 nets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
References: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Fri, 25 Feb 2011 20:52:32 +0200

> This is a new approach to the "share sysctl tables" RFC series I
> posted earlier this month.

I do not disagree conceptually with these changes from a networking
perspective, but I am not a sysctl layer expert so I don't know if the
generic sysctl bits are a good idea or not.
