Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2DPPLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:11:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52786 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753671Ab2DPPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:11:32 -0400
Date: Mon, 16 Apr 2012 11:11:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Jason Baron <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: ehci dynamic debug problem
In-Reply-To: <20120413190311.GA6238@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1204161110390.1408-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Johannes Stezenbach wrote:

> Anyway, maybe the dbg_*_buf() are not called often enough to worry?
> 
> If you're OK with "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
> then maybe you should just do that?

Actually I'm pretty busy now.  If you would like to submit a patch to 
do this, it would be great.

Alan Stern

