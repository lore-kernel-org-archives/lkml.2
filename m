Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1J2GYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 02:24:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64641 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1J2GYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 02:24:07 -0400
Date: Sat, 29 Oct 2011 09:20:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/staging/rtl8712/rtl871x_mlme.c: eliminate a
 null pointer dereference
Message-ID: <20111029062031.GF14881@longonot.mountain>
References: <1319846297-2985-1-git-send-email-julia@diku.dk>
 <4EAB5170.8000407@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAB5170.8000407@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EAB9BDF.00DC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 08:05:52PM -0500, Larry Finger wrote:
> I believe it is. It probably does not matter as I have never hit an
> oops at this location.
> 

You would only hit an Oops if you used a zero mac address for
pnetwork->MacAddress.

Julia's patch is turning on some code that was never tested to make
it the common case.  So it will be easy to see if it works or not
when it gets merged.  ;P  To me it could go either way, (the test is
reversed or the memcpy() could be removed).

regards,
dan carpenter

