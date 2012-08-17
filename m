Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2HQS1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:27:52 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:25139 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab2HQS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:27:24 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3c7pEgsE
X-RZG-CLASS-ID: mo00
Date: Fri, 17 Aug 2012 20:27:21 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
Message-ID: <20120817182721.GA7747@aepfle.de>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
 <20120817173209.GA29217@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120817173209.GA29217@decadent.org.uk>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, Ben Hutchings wrote:

> On Fri, Aug 17, 2012 at 09:51:09AM -0700, Greg KH wrote:
> > On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > > Now, gather DNS information. Invoke an external script (that can be
> > > distro dependent) to gather the DNS information.
> > 
> > Where is that script?  Why a script, this really isn't in a standard
> > method for all Linux distros?  If not, why not work to do that like the
> > freedesktop.org people have done for other system configuration items?
>  
> I suggested using the Network Manager D-Bus API.  That obviously
> isn't going to work everywhere, but it seems to cover the same simple
> cases that this hypervisor-guest interface allows for.

If its not going to work everywhere how can it be the solution?

The script in turn can do whatever it takes, which includes NM. However
NM (in its current state) shouldnt be thrown at everyone and everything.

Olaf
