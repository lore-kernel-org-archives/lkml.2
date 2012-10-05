Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2JEOOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:14:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35342 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754012Ab2JEOOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:14:39 -0400
Message-ID: <1349446478.2008.66.camel@joe-AO722>
Subject: Re: [PATCH] revert "PCI: log vendor/device ID always"
From: Joe Perches <joe@perches.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 05 Oct 2012 07:14:38 -0700
In-Reply-To: <506EE6D5.4010603@sgi.com>
References: <1349187780-25692-1-git-send-email-nzimmer@sgi.com>
	 <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com>
	 <506DB30F.2000704@sgi.com> <1349368662.2008.20.camel@joe-AO722>
	 <506EE6D5.4010603@sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 08:55 -0500, Nathan Zimmer wrote:
> On 10/04/2012 11:37 AM, Joe Perches wrote:
> > On Thu, 2012-10-04 at 11:02 -0500, Nathan Zimmer wrote:
> >> At many of our customer sites the log level is set to KERN_DEBUG. It
> >> helps avoid reboots due to operator impatience.  Machines this large
> >> take significantly longer then typical to boot and seeing the extra
> >> messages reassures them that the kernel isn't hung.
> > That argues for adding some KERN_INFO "still booting" messages
> > not logging unnecessary KERN_DEBUG messages.
> >
> Actually I would think that argues for reducing boot times on these 
> large systems.

Right.

That's an independent argument, but sure, go ahead
and do that too.



