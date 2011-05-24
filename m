Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1EXSex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:34:53 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58626 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582Ab1EXSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:34:52 -0400
X-Sasl-enc: JHDJHgA5+gjx+BZhBoxagqghdUtxixQYCELYLdoHGUtv 1306262091
Date: Tue, 24 May 2011 11:34:48 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: USBIP protocol documentation?
Message-ID: <20110524183448.GA18511@kroah.com>
References: <4DDBF8BD.3000603@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DDBF8BD.3000603@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 08:28:13PM +0200, Németh Márton wrote:
> Hi,
> 
> I'm looking for the USBIP protocol documentation. I found that
> there was already a discussion about the USBIP protocol and
> there is some draft about it:
> 
>   * http://marc.info/?l=linux-kernel&m=122001863119269&w=2
>   * http://www.kernel.org/pub/linux/kernel/people/willy/usbip/usbip-protocol-draft-1
> 
> Unfortunately I couldn't found any detailed protocol documentation
> on the project homepage:
> 
>   * http://usbip.sourceforge.net/#documentation
> 
> Do you know any follow-up on the USBIP protocol documentation?

I think the code is the "real" documentation.

Note a number of developers are actively working on changing the protocol
and fixing it up based on Matthew's previous comments.  Look at the
thread on the usbip project's mailing list for a few details.  More will
be in the patches produced by the developers.

good luck,

greg k-h
