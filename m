Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886Ab2EWPEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:04:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51774 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933655Ab2EWPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:03:58 -0400
Date: Wed, 23 May 2012 11:03:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
In-Reply-To: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205231103030.1566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> Another thing need to check is if system suspend/resume works.

Right!  Although I would hope that your work doesn't interfere at all 
with system sleep, since it touches only the runtime PM pathways.

Alan Stern

