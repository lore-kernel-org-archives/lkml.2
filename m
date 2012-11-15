Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2KOXiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:38:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52630 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2KOXiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:38:06 -0500
Date: Thu, 15 Nov 2012 15:38:02 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Tomas Hozza <thozza@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: Re: [PATCH 1/3] tools/hv: Fix /var subdirectory
Message-ID: <20121115233802.GA9414@kroah.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 03:56:14PM +0000, KY Srinivasan wrote:
> > -----Original Message-----
> > From: Tomas Hozza [mailto:thozza@redhat.com]

<snip>

KY, there have been a few of these tools/hv patches floating by, and you
haven't acked all of them from what I can tell.  I've applied some of
them, but I know I've missed some.  Can you please resend the ones I've
missed that Tomas has sent, but I've not applied?

thanks,

greg k-h
