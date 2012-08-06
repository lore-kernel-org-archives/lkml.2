Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2HFUrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:47:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39224 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2HFUri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:47:38 -0400
Date: Mon, 06 Aug 2012 13:47:37 -0700 (PDT)
Message-Id: <20120806.134737.1358773847818872075.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: vyasevich@gmail.com, jan.ariyasu@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.ariyasu@hp.com
Subject: Re: [PATCH 00/13] SCTP: Enable netns
From: David Miller <davem@davemloft.net>
In-Reply-To: <874noflrzd.fsf@xmission.com>
References: <87mx27rig7.fsf@xmission.com>
	<50201928.2030802@gmail.com>
	<874noflrzd.fsf@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 06 Aug 2012 12:50:46 -0700

> Vlad Yasevich <vyasevich@gmail.com> writes:
> 
> 
>> Hi Eric
>>
>> Associations are looked up by ports, but then verifyed by addresses.
>> Also, associations belong to sockets and simply validating the socket
>> namespace should be sufficient.
> 
> True.  Your set of patches isn't quite as likely to malfunction as it
> looked at first glance.  It requires address reuse which happens accross
> namespaces but not too frequently.
> 
> As for validating the socket namespace I agree that is the fix and my
> patchset winds up doing it.

FWIW I much prefer Eric's patch set, it was so significantly easier to
read and validate than Jan's.
