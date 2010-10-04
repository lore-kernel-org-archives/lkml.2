Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0JDVBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:01:36 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24031 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0JDVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:01:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 04 Oct 2010 17:01:34 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] vcs: add poll/fasync support
In-reply-to: <20101001103142.352f42a2@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.00.1010041657580.3107@xanadu.home>
References: <alpine.LFD.2.00.1009302320360.1146@xanadu.home>
 <20101001103142.352f42a2@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010, Alan Cox wrote:

> > Not to create unwanted overhead, the needed data structure is allocated
> > and the vt notification callback is registered only when the poll or
> > fasync method is invoked for the first time per file instance.
> 
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

So, who should pick those patches up?

Just making sure they won't fall into a crack.


Nicolas
