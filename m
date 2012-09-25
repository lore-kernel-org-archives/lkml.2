Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2IYLkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:40:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47409 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2IYLkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:40:47 -0400
Date: Tue, 25 Sep 2012 14:40:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant <emailgrant@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: Backlight control broken between 3.6.0-rc1 and 3.6.0-rc4
Message-ID: <20120925114036.GE5368@mwanda>
References: <CAN0CFw1GiAZxLcRGaEOxYcGhOfF2hjDuoF+e0T8r_ZryTFzw5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN0CFw1GiAZxLcRGaEOxYcGhOfF2hjDuoF+e0T8r_ZryTFzw5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 04:25:10AM -0700, Grant wrote:
> I have a Dell XPS 13 Ultrabook laptop.  Backlight control used to be
> broken, it works in 3.6.0-rc1, and it is broken again in 3.6.0-rc4.
> 

I've filed a bug for this.
https://bugzilla.kernel.org/show_bug.cgi?id=47941

Please add the following information:
*) Complete dmesg
*) lsmod, working and non-working
*) .config

regards,
dan carpenter
