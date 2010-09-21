Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab0IUOOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:14:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:57511 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab0IUOOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:14:44 -0400
Date: Tue, 21 Sep 2010 16:14:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Ott <alan@signal11.us>, Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        USB list <linux-usb@vger.kernel.org>, linux-input@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        simon@mungewell.org, Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH 1/1] Don't Send Feature Reports on Interrupt Endpoint
In-Reply-To: <Pine.LNX.4.44L0.1009160949500.1695-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1009211614160.26813@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1009160949500.1695-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Alan Stern wrote:

> That's all fine, and I have no objection to the patch itself.  You 
> should include (in brief form) some of this explanation in the patch 
> description so that people will know _why_ this has to be done.

Fully, agreed. Alan, could you please write a short description into the 
patch changelog and resubmit it to me?

Thanks a lot,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
