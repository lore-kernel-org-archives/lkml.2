Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2KMThe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:37:34 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33534 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754695Ab2KMThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:37:32 -0500
Message-ID: <1352835444.16401.107.camel@thor>
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Date: Tue, 13 Nov 2012 14:37:24 -0500
In-Reply-To: <20121112235154.GA14017@kroah.com>
References: <1350565015.23730.4.camel@thor>
	 <cover.1351817601.git.peter@hurleysoftware.com>
	 <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
	 <20121113003338.6aafd7c8@stein> <20121112235154.GA14017@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 15:51 -0800, Greg Kroah-Hartman wrote:
> On Tue, Nov 13, 2012 at 12:33:38AM +0100, Stefan Richter wrote:
> > On Nov 02 Peter Hurley wrote:
> > > This patch provides the kernel driver for high-speed TTY
> > > communication over the IEEE 1394 bus.
> > > 
> > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > 
> > Hi Greg,
> > 
> > you asked for an Ack.  Here it is:  I am OK with this getting added to the
> > staging tree.
> 
> Thanks, I'll queue it up later this week when I return from my travels.

Thanks, Greg.

Except for your and Alan's earlier concerns, which I think I addressed,
I didn't get any other feedback on the TTY side of things. Are you
personally reviewing this submission?

Regards,
Peter Hurley


