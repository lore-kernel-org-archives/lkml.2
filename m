Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1JLTf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:35:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27838 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1JLTfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:35:54 -0400
Date: Wed, 12 Oct 2011 22:32:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: comedi: fix printk issue in das6402.c
Message-ID: <20111012193258.GH18470@longonot.mountain>
References: <1318422405-12101-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318422405-12101-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090201.4E95EC15.0095,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaks the build.  I am not going to review the other three, and I'm
going to make renewed effort to figure out procmail.

regards,
dan carpenter

