Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0CQGee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab0CQGed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:34:33 -0400
Message-ID: <4BA078D1.3090605@redhat.com>
Date: Wed, 17 Mar 2010 14:38:09 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] netpoll: allow spaces in its parameter
References: <4BA07022.1040702@redhat.com>	<20100316.225950.222623826.davem@davemloft.net>	<4BA071BD.5040900@redhat.com> <20100316.231434.177653499.davem@davemloft.net>
In-Reply-To: <20100316.231434.177653499.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Cong Wang <amwang@redhat.com>
> Date: Wed, 17 Mar 2010 14:07:57 +0800
> 
>> No, but silently accepting it as 0 is not correct, why don't
>> reject it if it is not allowed?
> 
> You have to be careful even with that.  For example, if two
> netconsoles are specified, seeing the space shouldn't
> kill the first netconsole specification we parsed.
> 
> A warning perhaps, but outright rejection of all specifications is
> really bad behavior.

OK, I will put a warning there instead.

Thanks, David!

