Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab2JXP42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:56:28 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:44911 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756985Ab2JXP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:56:26 -0400
Message-ID: <1351094179.8875.86.camel@thor>
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Wed, 24 Oct 2012 11:56:19 -0400
In-Reply-To: <20121024154141.3029ad92@stein>
References: <1350565015.23730.4.camel@thor>
	 <20121022224505.GD24489@kroah.com> <20121024154141.3029ad92@stein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  drivers/staging/fwserial/dma_fifo.c |  310 ++++
> > >  drivers/staging/fwserial/dma_fifo.h |  130 ++
> > >  drivers/staging/fwserial/fwserial.c | 2885 +++++++++++++++++++++++++++++++++++
> > >  drivers/staging/fwserial/fwserial.h |  355 +++++
> 
> drivers/firewire/net.c is 1721 lines, sbp_target is 2868 lines.
> Why is fwserial bigger?

1) Exclude the dma_fifo* files in the comparison, because block & net
devices get dma-able memory management from their subsystems.
2) Certain tty concepts don't map well to an automated bus, so these are
simulated (eg, break handling)
3) fwserial has to implement a protocol to virtually cable peers
4) sbp_target only supports 1 target.


