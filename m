Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3AHO7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:59:23 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49713 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756440Ab3AHO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:59:21 -0500
Message-ID: <1357657153.3420.3.camel@thor.lan>
Subject: Re: [PATCH v2 0/5] staging/fwserial: Address reviewer comments
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 08 Jan 2013 09:59:13 -0500
In-Reply-To: <20130107232206.GA15244@kroah.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
	 <20130107232206.GA15244@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 15:22 -0800, Greg Kroah-Hartman wrote:
> On Sat, Dec 15, 2012 at 01:03:14AM -0500, Peter Hurley wrote:
> > Overdue respin.
> > v2 changes:
> >    Don't use 'card' when referring to firewire node
> >    Removed lower clamp in link_speed_to_max_payload()
> >    Ripped out the bandwidth limit logic
> >    Drop suggestion to integrate link_speed_to_max_payload()
> >      & device_max_receive()
> >    Note required minimum max_rec value for OHCI-compliant devices
> 
> Ugh, I applied the first version of this series, many apologies.  Can
> you send me follow-on patches with just the differences here?

I saw that - no worries. I'll send follow-on patches today or tomorrow.

Regards,
Peter Hurley



