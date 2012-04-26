Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2DZGgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:36:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25154 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2DZGgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:36:12 -0400
Date: Thu, 26 Apr 2012 09:38:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix bug where kfree is called twice.
Message-ID: <20120426063858.GC6447@mwanda>
References: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a good patch and it fixes a bug, but could you resend with
the subject:

[PATCH] Staging: ozwpan: Fix bug where kfree is called twice.

We don't like to put a lot of bureaucracy infront of people
submitting actual bugfixes.  But you guys are the new maintainers
and you're going to need to know all this stuff eventually.  Also
could you give us a hint how likely the users are to hit this?
Should this go into 3.4 or only 3.5?

regards,
dan carpenter

