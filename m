Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1KYMeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:34:23 -0500
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1164 "EHLO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1KYMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:34:22 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7250
Message-ID: <4ECF8B77.2070304@metafoo.de>
Date: Fri, 25 Nov 2011 13:35:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] iio: iio_event_getfd -- fix ev_int build failure
References: <1322218582-4271-1-git-send-email-apw@canonical.com>
In-Reply-To: <1322218582-4271-1-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 11:56 AM, Andy Whitcroft wrote:
> Fix build failure in staging iio driver:
> 
> .../drivers/staging/iio/industrialio-core.c: In function 'iio_event_getfd':
> .../drivers/staging/iio/industrialio-core.c:262:32: error:
> 			'ev_int' undeclared (first use in this function)
> 
> Also convert the rest of the function to use the new variable.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Hi Andy,

I think your patch is number 6 for this bug. A fix should already be on it's
way.


Thanks,
- Lars
