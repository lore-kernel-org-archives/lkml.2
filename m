Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2EULds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:33:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17549 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2EULdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:33:47 -0400
Date: Mon, 21 May 2012 14:37:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nasir Abed <nasirabed@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, swetland@google.com
Subject: Re: [PATCH] Staging: android: alarm: Rename pr_alarm to alarm_dbg
Message-ID: <20120521113729.GB4629@mwanda>
References: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
 <alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com>
 <1337546284.31503.5.camel@joe2Laptop>
 <1337547996.31503.8.camel@joe2Laptop>
 <alpine.DEB.2.00.1205201426430.10189@chino.kir.corp.google.com>
 <CAMXkaZE_D7wFZ1PzZgwG8hL7wqvLFaP=M=9OAP08fz7zj2dBUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMXkaZE_D7wFZ1PzZgwG8hL7wqvLFaP=M=9OAP08fz7zj2dBUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 12:49:33PM +0200, Nasir Abed wrote:
> Shouldn't:
> [PATCH] Staging: android: alarm: Rename pr_alarm to alarm_dbg
> Be:
> [PATCH] Staging: android: alarm-dev: Rename pr_alarm to alarm_dbg
> 

Or even better "Staging: android-alarm:" but nobody cares one way or
the other.  Stop bellyaching about nonsense things.  :P

regards,
dan carpenter

