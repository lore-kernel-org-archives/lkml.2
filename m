Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2EFGdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 02:33:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18790 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2EFGd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 02:33:28 -0400
Date: Sun, 6 May 2012 09:34:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com,
        andor.daam@googlemail.com, grabner@icg.tugraz.at, jj@chaosbits.net,
        thomas@m3y3r.de
Subject: Re: [PATCH 1/8] drivers/staging/line6/control.c: Change
 strict_strtoul to kstrtoul
Message-ID: <20120506063450.GH22134@mwanda>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
 <1336228312-5379-2-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336228312-5379-2-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 04:31:45PM +0200, Johannes Thumshirn wrote:
> Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy
> 

This would probably be better as kstrtou8(). You'd have to change
the type of value, and the function parameters which take value as
well.  Also you would have to change the name of pod_set_param_int()
because it says "int".


regards,
dan carpenter

