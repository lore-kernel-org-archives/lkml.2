Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2FNRZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:25:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31070 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2FNRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:25:49 -0400
Date: Thu, 14 Jun 2012 20:25:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wfg@linux.intel.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: automated warning notifications
Message-ID: <20120614172523.GB4400@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

I also check new static checker warnings and sometimes email people.
I wonder if we are duplicating each others work.  For example, did
you send an email asking about the following Sparse warning:

sound/soc/codecs/ab8500-codec.c:1959:53: warning: cast truncates bits from constant value (1013 becomes 13)

Quite often those messages are false positive and the value is
truncated deliberately.  In this case it looks suspicious and I
would maybe email about it.  If I knew what kind of messages you
check and which you ignore that would help me.

Perhaps there is an email list I could subscribe to to see if you
had already sent a message.

regards,
dan carpenter
