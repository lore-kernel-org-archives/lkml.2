Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262Ab2EQRqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:46:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47508 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756323Ab2EQRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:46:05 -0400
Date: Thu, 17 May 2012 13:46:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [RFC v2 PATCH 1/4] block: add a flag to identify PM request
In-Reply-To: <1337269686-3781-2-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1205171345190.1169-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012, Lin Ming wrote:

> Add a flag REQ_PM to identify the request is PM related.
> As an example, modify scsi code to use this flag.

Some systems need to use the SCSI error handler during suspend and 
resume.  You'll need to mark every command sent by the error handler 
with the REQ_PM flag.

Alan Stern

