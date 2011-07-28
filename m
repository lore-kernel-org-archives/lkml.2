Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1G1DZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 23:25:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33330 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1G1DZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 23:25:37 -0400
Date: Wed, 27 Jul 2011 20:23:54 -0700 (PDT)
Message-Id: <20110727.202354.869957455531006377.davem@davemloft.net>
To: jmorris@namei.org
Cc: torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: Re: [GIT] Security subsystem changes for 3.1
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1107281316550.5116@tundra.namei.org>
References: <alpine.LRH.2.00.1107281240330.4840@tundra.namei.org>
	<CA+55aFyyROrBFuwKTWkEWpe=iF=E68bQicQcBpTFrx6Bj2RaBw@mail.gmail.com>
	<alpine.LRH.2.00.1107281316550.5116@tundra.namei.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 27 Jul 2011 20:23:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>
Date: Thu, 28 Jul 2011 13:20:35 +1000 (EST)

> Ok.  So what should have happened here (fb408e6ccc) is that Al should have 
> emailed the patch to me to apply to my tree, instead of pushing it 
> directly?

I think Linus is trying to say that you should have not done the merge
to resolve the conflict and simply let him take care of it when he
pulled your tree.
