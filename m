Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0IUPK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:10:58 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:53603 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0IUPK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:10:57 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 2/2] staging: hv: Remove camel cases from vmbus channel
 functions
Thread-Topic: [PATCH 2/2] staging: hv: Remove camel cases from vmbus channel
 functions
Thread-Index: AQHLWQixMaGUjEdPd06Cf8+WB9z/TJMb+pWAgACQOvA=
Date: Tue, 21 Sep 2010 15:10:50 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289E6554F@TK5EX14MBXC121.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7289E499E4@TK5EX14MBXC121.redmond.corp.microsoft.com>
 <20100920232921.GA31204@kroah.com>
In-Reply-To: <20100920232921.GA31204@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, September 20, 2010 7:29 PM
> Function name changes are one thing.
> 
> Variable names are another thing.
> 
> Again, one patch per thing please.
> 
> It's easier to read and verify that everything is sane.
> 
> Please try this one again.

I will separate the variable names and function names into two patches,
And, incorporate your suggestions like - naming the functions as vmbus_*
instead of vmbus_channel_*, updating the comments, and etc..

Thanks,

- Haiyang
