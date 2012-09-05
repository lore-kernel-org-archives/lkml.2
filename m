Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab2IETOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:14:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64064 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab2IETOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:14:42 -0400
Date: Wed, 5 Sep 2012 12:12:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "thozza@redhat.com" <thozza@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dcbw@redhat.com" <dcbw@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: Re: [PATCH V4 05/10] Tools: hv: Add an example script to retrieve
 dhcp state
Message-ID: <20120905191208.GB2085@kroah.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-5-git-send-email-kys@microsoft.com>
 <20120904225917.GB3725@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9309DFFA2@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120905000419.GC31997@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9309DFFBE@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <426367E2313C2449837CD2DE46E7EAF9309E007C@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9309E007C@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 02:25:28AM +0000, KY Srinivasan wrote:
> > I can certainly resubmit this patch with the change you are suggesting. This patch
> > adds a new file
> > and does not impact any of the other patches that follows this. Would you want
> > me to resubmit all of the
> > remaining patches starting with this one.
> 
> I have resent this patch with the change you have suggested. Since this patch is a 
> standalone patch I have not resent the other patches that follow this patch. Let me
> know if you want me to resend the remaining patches.

Please resend all of them, I no longer have them in my to-apply queue.

greg k-h
