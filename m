Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2I1MT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:19:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45938 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2I1MT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:19:26 -0400
Date: Fri, 28 Sep 2012 15:19:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kevin Cruz <skate_ops@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi can't connect to router after resuming from suspend.
Message-ID: <20120928121917.GF5368@mwanda>
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> Linux cyber-ubuntu 3.2.0-30-generic #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

That kernel is too old.  Can you test with a 3.5.x kernel (or even
better would be a 3.6-rc kernel).  Those are the only ones we look
at on lkml.

regards,
dan carpenter
