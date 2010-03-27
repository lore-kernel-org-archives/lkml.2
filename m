Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0C0Pb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:31:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53693
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab0C0Pbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:31:55 -0400
Date: Sat, 27 Mar 2010 08:32:19 -0700 (PDT)
Message-Id: <20100327.083219.104064186.davem@davemloft.net>
To: ajitk@serverengines.com, ajitkhaparde@gmail.com
Cc: wzt.wzt@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-drivers@serverengines.com, sathyap@serverengines.com
Subject: Re: [PATCH] benet: Fix compile warnnings in
 drivers/net/benet/be_ethtool.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100326171616.GA20879@serverengines.com>
References: <20100326061259.GB30341@localhost.localdomain>
	<20100326171616.GA20879@serverengines.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajit Khaparde <ajitkhaparde@gmail.com>
Date: Fri, 26 Mar 2010 22:46:18 +0530

> On 26/03/10 14:12 +0800, wzt.wzt@gmail.com wrote:
>> Fix the following warnings:
>> 
>> be_ethtool.c:493: warning: integer constant is too large for 'long' type
>> be_ethtool.c:493: warning: integer constant is too large for 'long' type
>> 
>> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
> I would suggest using be2net instead of benet during the commit. 
> be2net: Fix compile warnnings in drivers/net/benet/be_ethtool.c
> 
> Acked-by: Ajit Khaparde <ajitk@serverengines.com>

Well, you cannot be surprised that people will use "benet"
since that is the name of the directory the driver lives
under.  It is not even referred to as "be2net" in the
MAINTAINERS entry.

I'm applying this fix as-is.
