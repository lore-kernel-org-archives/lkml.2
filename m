Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1EXVaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:30:10 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53695 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224Ab1EXV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:29:19 -0400
X-Sasl-enc: 2bToz+dRdP5IxP/CK3WyJZp+lG51zi9IprOcVifJAHaM 1306272558
Date: Tue, 24 May 2011 14:25:16 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, Matt Mooney <mfm@muteddisk.com>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol documentation?
Message-ID: <20110524212516.GB24134@kroah.com>
References: <4DDBF8BD.3000603@freemail.hu>
 <20110524183448.GA18511@kroah.com>
 <4DDC142E.6070003@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DDC142E.6070003@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:25:18PM +0200, Németh Márton wrote:
> The current protocol implementation is based on top of TCP. In the message
> at http://marc.info/?l=linux-kernel&m=122001883519653&w=2 the SCTP is mentioned.
> Have anybody worked on finding out what benefits the SCTP could give to USBIP
> and what would be the drawbacks?

It might not work well on Windows, which the current code does today.

I think that the TCP vs. SCTP is the least of the protocol issues at the
moment, there are lots of other things to work on :)

greg k-h
