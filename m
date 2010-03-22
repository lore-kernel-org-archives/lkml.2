Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0CVUvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:51:06 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:58925 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab0CVUvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:51:03 -0400
Date: Mon, 22 Mar 2010 13:51:01 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN	module
Message-ID: <20100322205101.GC19327@ovro.caltech.edu>
References: <20100319151914.GB13672@ovro.caltech.edu>
 <4BA39C05.8050800@grandegger.com>
 <20100319200325.GE13672@ovro.caltech.edu>
 <4BA3DAF1.4090206@grandegger.com>
 <20100319215227.GF13672@ovro.caltech.edu>
 <4BA47F64.8030108@grandegger.com>
 <20100322155318.GA19251@ovro.caltech.edu>
 <4BA7C236.9060609@grandegger.com>
 <20100322201039.GA19327@ovro.caltech.edu>
 <4BA7D2E9.6010007@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7D2E9.6010007@grandegger.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 22 Mar 2010 13:51:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 09:28:25PM +0100, Wolfgang Grandegger wrote:

[ big snip ]

> 
> You could even add the tx/rx values for each error message (for both,
> state changes and bus-errors).
> 

Ok, with that change, I get the following:

berr-reporting on:

  can0  20000088  [8] 00 00 80 19 00 00 08 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 10 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 18 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 20 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 28 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 30 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 38 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 40 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 48 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 50 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 58 00   ERRORFRAME
  can0  20000004  [8] 00 08 00 00 00 00 60 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 60 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 68 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 70 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 78 00   ERRORFRAME
  can0  20000004  [8] 00 20 00 00 00 00 80 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 80 00   ERRORFRAME
  can0  20000088  [8] 00 00 80 19 00 00 80 00   ERRORFRAME

And now lots more of this last frame repeated, until the controller
decides to stop. Seems fine. It has always done this.

berr-reporting off:

  can1  20000004  [8] 00 08 00 00 00 00 60 00   ERRORFRAME
  can1  20000004  [8] 00 20 00 00 00 00 80 00   ERRORFRAME


Same as before. Excellent.

> > I haven't heard back from Samuel Ortiz yet about the changes for the mfd
> > layer. Would you like me to send out my latest CAN driver changes, or
> > should I just wait until I hear back?
> 
> As you need patch 1/3 anyway, just wait some more time. From my point of
>  view the next version of the patch will be OK.
> 

Ok, I'll wait a few more days before pinging him again. He's CC'd on all
of these emails anyway. :)

Thanks for all the help,
Ira
