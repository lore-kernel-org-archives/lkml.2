Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0GZXKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 19:10:45 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:36936 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0GZXKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 19:10:44 -0400
X-MXL-Hash: 4c4e15f47812d055-63f24bf9138dfd9fba328534db08cabff6bce605
X-MXL-Hash: 4c4e15dc2063bc81-cf689b15213bfab2328d2efeb34a647d1dede76f
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "joe@perches.com" <joe@perches.com>, "ss@aao.gov.au" <ss@aao.gov.au>,
        "gregkh@suse.de" <gregkh@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jul 2010 18:09:44 -0500
Subject: RE: [PATCH v2] Staging: dt3155: make local variables static
Thread-Topic: [PATCH v2] Staging: dt3155: make local variables static
Thread-Index: AcstE6Onuz8DX3TdTdCS7yuskxEjHAAA9q+w
Message-ID: <0D753D10438DA54287A00B02708426976374262C88@AUSP01VMBX24.collaborationhost.net>
References: <201007231303.34672.hartleys@visionengravers.com>
 <20100726223440.GA16147@kroah.com>
In-Reply-To: <20100726223440.GA16147@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=Uv1rPhjL97YA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=EsJUynW6WGMZq1uWvpUA]
X-AnalysisOut: [:9 a=qUMn6dUkowd2yIH5R40hsqdsmQoA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 26, 2010 3:35 PM, Greg KH wrote:
> On Fri, Jul 23, 2010 at 01:03:34PM -0700, H Hartley Sweeten wrote:
>> The symbols dt3155_dev_open, unique_tag, and allocatorAddr are only used in
>> the file dt3155_drv.c and should be static. Also, as pointed out by Joe Perches,
>> static variables do not need initialization so remove them. While here, also
>> move the definition for allocatorAddr so that all the variables are declared at
>> one place in the code.
>
> This doesn't apply after applying your previous patch to this file :(

Oops.. I'll fix it up and repost.

Regards,
Hartley