Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab1J3QQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 12:16:52 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:59060 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934222Ab1J3QQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 12:16:50 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: RE: [PATCH 0/3] Staging: hv: mousevsc: cleanup the mouse driver
Thread-Topic: [PATCH 0/3] Staging: hv: mousevsc: cleanup the mouse driver
Thread-Index: AQHMlbsDd2xOsGdq/0SBf8Dy+aakW5WTNkYAgAAnKaA=
Date: Sun, 30 Oct 2011 16:16:48 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA544DF@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1319839847-28959-1-git-send-email-kys@microsoft.com>
 <20111029044952.GA1061@kroah.com>
In-Reply-To: <20111029044952.GA1061@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Saturday, October 29, 2011 12:50 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> joe@perches.com; dmitry.torokhov@gmail.com; jkosina@suse.cz
> Subject: Re: [PATCH 0/3] Staging: hv: mousevsc: cleanup the mouse driver
> 
> On Fri, Oct 28, 2011 at 03:10:47PM -0700, K. Y. Srinivasan wrote:
> > Further cleanup to move the mouse driver out of staging.
> > This patch-set addresses the comments I have  received from Jiri, Joe and Greg.
> > Thank you for taking the time to review the code.
> 
> Please note, all of this work is too late for the 3.2 merge, as it
> needed to be completed weeks ago for that to happen.  And, as we are in
> the middle of the merge, our time allocated to reviewing new patches is
> quite limited.
> 
> So you might have a lot better success in just waiting a few weeks so
> that we then have the time to review and address all of these cleanup
> patches and requests to move the hyperv drivers.
> 
> I know I'm not going to be accepting any such patches from anyone other
> than pure-bugfixes for the next 2-3 weeks at the least.

Thanks Greg. I want to be close to being  "first in line" when you are ready to accept patches!
These patches really have addressed the issues Jiri, you and other found as part
of the review process. I am hoping Jiri will be able to pick up the patch to move the 
driver out of staging.

Regards,

K. Y
