Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2JMR2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 13:28:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43076 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JMR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 13:28:52 -0400
Date: Sun, 14 Oct 2012 02:28:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] tools: hv: Return the full kernel version
Message-ID: <20121013172843.GA11040@kroah.com>
References: <1350085210-11108-1-git-send-email-kys@microsoft.com>
 <20121013064435.GA9794@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF930A35B29@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930A35B29@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 04:03:31PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Saturday, October 13, 2012 2:45 AM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com
> > Subject: Re: [PATCH 1/1] tools: hv: Return the full kernel version
> > 
> > On Fri, Oct 12, 2012 at 04:40:10PM -0700, K. Y. Srinivasan wrote:
> > > Currently, we are returning the same string for both OSBuildNumber
> > > and OSVersion keys. Return the full uts string for the OSBuild
> > > key since Windows does not impose any restrictions on this.
> > 
> > You sent me 2 patches, both 1/1, that modify the same file.  Which one
> > comes first?  Please resend both properly, and also let me know if these
> > are things that should be going into 3.7 or can wait for 3.8.
> 
> Initially,  I sent them out in the order I wanted them
> applied. I will resend them as a patch set. They can wait for 3.8.

The "order" you send them isn't always the order they are received by
people, that is why you need to have the X/2 numbering scheme.

greg k-h
