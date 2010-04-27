Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0D0SXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:23:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751093Ab0D0SXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:23:43 -0400
Date: Tue, 27 Apr 2010 14:23:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: Robert Hancock <hancockrwd@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Invalid opcode on resume from STR on Asus P4P800-VM
In-Reply-To: <201004271205.17369.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.1004271422170.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Ondrej Zary wrote:

> > It looks like idle=nomwait should be the workaround with the least
> > impact at the moment..
> 
> It does not work for me.

Not surpisingly, since mwait_usable() ignores the idle_nomwait flag.  
Maybe that's a bug and should be fixed -- I don't know.

Alan Stern

