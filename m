Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1EIU4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:56:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44983
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab1EIU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:56:05 -0400
Date: Mon, 09 May 2011 13:55:32 -0700 (PDT)
Message-Id: <20110509.135532.200362374.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, hadi@cyberus.ca,
        daniel.lezcano@free.fr, containers@lists.osdl.org,
        renatowestphal@gmail.com
Subject: Re: [PATCH 0/7] Network namespace manipulation with file
 descriptors
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1bozbtx0y.fsf@fess.ebiederm.org>
References: <m1oc3btzk4.fsf@fess.ebiederm.org>
	<20110509.134007.116389415.davem@davemloft.net>
	<m1bozbtx0y.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 May 2011 13:54:37 -0700

> Do you know if there are any plans to support sendmmsg on parisc for
> 2.6.40?  That could get sticky as the parisc tree has a bunch of syscall
> catchup support they are doing now.

If you would like, you could send me a patch for net-next-2.6 that adds
the sendmmsg syscall entries and hooks for all the platforms not taken
care of right now.
