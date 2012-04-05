Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2DEXIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:08:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60936 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2DEXIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:08:00 -0400
Date: Thu, 05 Apr 2012 19:06:49 -0400 (EDT)
Message-Id: <20120405.190649.1829697650143132541.davem@davemloft.net>
To: remi@remlab.net
Cc: levinsasha928@gmail.com, remi.denis-courmont@nokia.com, davej@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] phonet: Check input from user before allocating
From: David Miller <davem@davemloft.net>
In-Reply-To: <201204052214.55669.remi@remlab.net>
References: <1333663665-3999-1-git-send-email-levinsasha928@gmail.com>
	<201204052214.55669.remi@remlab.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 05 Apr 2012 16:06:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rémi Denis-Courmont" <remi@remlab.net>
Date: Thu, 5 Apr 2012 22:14:54 +0300

> Le vendredi 6 avril 2012 01:07:45 Sasha Levin, vous avez écrit :
>> A phonet packet is limited to USHRT_MAX bytes, this is never checked during
>> tx which means that the user can specify any size he wishes, and the kernel
>> will attempt to allocate that size.
>> 
>> In the good case, it'll lead to the following warning, but it may also
>> cause the kernel to kick in the OOM and kill a random task on the server.
 ...
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

Applied and queued up for -stable, thanks.
