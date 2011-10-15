Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1JOTI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:08:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46546 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754525Ab1JOTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:08:54 -0400
Date: Sat, 15 Oct 2011 15:08:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Johannes Stezenbach <js@sig21.net>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <CA+O4pCKbJCtF53jUBvQMX+zgPZ=YxCwGHyP-8JMx=++d5sCiCA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110151507540.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, Markus Rechberger wrote:

> I can send a sample device in around one month to Alan so he can have a look
> at it with the bus analyzer. However I would be happy to see Alan's
> proposal about the
> 16 MB limitations included since that one also solves the issue and even USB 3.0
> would benefit from this as it seems.

I'll post a pair of patches in a few days, after I finish testing them.

Alan Stern

