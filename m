Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2EVQKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:10:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46087 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759882Ab2EVQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:10:32 -0400
Date: Tue, 22 May 2012 12:10:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
In-Reply-To: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1205221209530.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> Hi,
> 
> In August 2010, Jens and Alan discussed about "Runtime PM and the block
> layer". http://marc.info/?t=128259108400001&r=1&w=2
> 
> Here are the RFC v3 patches that try to implement the ideas discussed.
> Welcome to give it a try.

Have you checked to make sure these changes won't break the IDE driver?  
Maybe it will need to set the REQ_PM flag too.

Alan Stern

