Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0FRHQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:16:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:41272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0FRHQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:16:17 -0400
Subject: Re: [patch] Over schedule issue fixing
From: Peter Zijlstra <peterz@infradead.org>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       yanmin.zhang@intel.com, tim.c.chen@intel.com
In-Reply-To: <1276835101.2118.185.camel@debian>
References: <1276754893.9452.5442.camel@debian>
	 <1276835101.2118.185.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 09:16:16 +0200
Message-ID: <1276845376.27822.1451.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 12:25 +0800, Alex,Shi wrote:
> Add Suresh and Peter into thread. 
> Would you like to give some comments of this issue? 

I took it, I looked at curing the issue differently but they all ended
up being more work.

Thanks
