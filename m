Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2LOQJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 11:09:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55878 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2LOQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 11:09:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Dec 2012 17:09:12 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] staging/fwserial: Drop suggestion for helper fn
 integration
Message-ID: <20121215170912.54c38780@stein>
In-Reply-To: <20121215133410.0b6add5c@stein>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
	<1355551400-8204-7-git-send-email-peter@hurleysoftware.com>
	<20121215133410.0b6add5c@stein>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Dec 15 Peter Hurley wrote:
> > The firewire core does not require or want the suggested helper fns;
> > drop suggestion from TODO file.

PS,
the patch and the other five look good to me.
-- 
Stefan Richter
-=====-===-- ==-- -====
http://arcgraph.de/sr/
