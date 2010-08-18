Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0HROcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:32:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0HROcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:32:15 -0400
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
From: James Bottomley <James.Bottomley@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com,
        LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
In-Reply-To: <4C6BC72E.6040607@gmail.com>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>
	 <20100817223145.GC4641@Krystal>  <4C6BC72E.6040607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 09:32:10 -0500
Message-ID: <1282141930.3035.9.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 13:42 +0200, Jiri Slaby wrote:
> On 08/18/2010 12:31 AM, Mathieu Desnoyers wrote:
> > * Jiri Slaby (jirislaby@gmail.com) wrote:
> >> On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
> >>> This is with these changes applied:
> >>
> >> Hi, these are very wrong. Please use ones from:
> >> http://lkml.org/lkml/2010/8/12/98
> > 
> > Yep, my system boot fine now.
> > 
> > Any plans to fast-track these fixes to mainline ?
> 
> Neil sent a pull request for the raid fixup earlier today.
> 
> James and Jens, could you take the two remaining (SCSI and BLOCK)?

Sure ... could you identify the email by subject, please? lkml.org seems
to be down this morning.

James


