Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2KZVMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:12:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:33804 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab2KZVMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:12:13 -0500
Date: Mon, 26 Nov 2012 13:12:11 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Tomas Hozza <thozza@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: Re: [PATCH 1/3] tools/hv: Fix /var subdirectory
Message-ID: <20121126211211.GA24858@kroah.com>
References: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <1352710506-12590-1-git-send-email-thozza@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF930E5A907@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E5A907@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 08:42:40PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Tomas Hozza [mailto:thozza@redhat.com]
> > Sent: Monday, November 12, 2012 3:55 AM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; KY Srinivasan; ben@decadent.org.uk
> > Cc: Tomas Hozza
> > Subject: [PATCH 1/3] tools/hv: Fix /var subdirectory
> > 
> > Initial patch by Ben Hutchings <ben@decadent.org.uk>
> > 
> > We will install this in /usr, so it must use /var/lib for its state.
> > Only programs installed under /opt should use /var/opt.
> > 
> > Signed-off-by: Tomas Hozza <thozza@redhat.com>
> Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

As I stated before, you need to rediff these, and resend them to me, I
have no more hyperv patches in my queue to apply.

greg k-h
