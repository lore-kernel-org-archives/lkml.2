Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2I2HZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:25:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42986 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab2I2HZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:25:36 -0400
Date: Sat, 29 Sep 2012 10:25:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kevin Cruz <skate_ops@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi can't connect to router after resuming from suspend.
Message-ID: <20120929072527.GA13767@mwanda>
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
 <20120928121917.GF5368@mwanda>
 <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:15:15PM -0700, Kevin Cruz wrote:
> Hey Dan,
> 
> 
> Thanks for the response.
> 
> >> Linux cyber-ubuntu 3.2.0-30-generic #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> 
> > That kernel is too old.  Can you test with a 3.5.x kernel (or even
> > better would be a 3.6-rc kernel).  Those are the only ones we look
> > at on lkml.
> 
> I did try out Sabayon 10 live disk because it said it uses the kernel 3.5.4
> but it did not fix the problem. I will definitely try to figure a way to
> test the 3.6-rc kernel.  Do you know any (experimental?) distros that are
> using it?  Is there anything else that I could do that could help, like
> rerunning any commands/script on a newer kernel?

You can compile it under ubuntu.  I looked on google to find
directions but everyone had bad advice.  This might work:

apt-get build-dep linux-image-$(uname -r)
download and unpack the kernel from kernel.org
make localmodconfig
make
make modules_install install
reboot

If it doesn't then having the dmesg from Sabayon live disk will have
to be enough.  We can open a bug for that on bugzilla and CC the
wireless people.

regards,
dan carpenter

