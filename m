Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2EFI13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 04:27:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55809 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2EFI10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 04:27:26 -0400
Message-ID: <1336292842.7144.2.camel@blackbook>
Subject: Re: [PATCH 1/8] drivers/staging/line6/control.c: Change
 strict_strtoul to kstrtoul
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com,
        andor.daam@googlemail.com, grabner@icg.tugraz.at, jj@chaosbits.net,
        thomas@m3y3r.de
Date: Sun, 06 May 2012 10:27:22 +0200
In-Reply-To: <20120506063450.GH22134@mwanda>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
	 <1336228312-5379-2-git-send-email-morbidrsa@googlemail.com>
	 <20120506063450.GH22134@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-06 at 09:34 +0300, Dan Carpenter wrote:
> On Sat, May 05, 2012 at 04:31:45PM +0200, Johannes Thumshirn wrote:
> > Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy
> > 
> 
> This would probably be better as kstrtou8(). You'd have to change
> the type of value, and the function parameters which take value as
> well.  Also you would have to change the name of pod_set_param_int()
> because it says "int".
> 
> 
> regards,
> dan carpenter
> 

Ok I'll look over these patches again, but I've got another question
regarding these, should I re-diff against the current linux-next or
against these patches?

regards,
Johannes Thumshirn

