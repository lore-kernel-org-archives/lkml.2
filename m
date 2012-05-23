Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145Ab2EWPSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:18:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39470 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EWPSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:18:05 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205231103030.1566-100000@iolanthe.rowland.org>
References: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
	<Pine.LNX.4.44L0.1205231103030.1566-100000@iolanthe.rowland.org>
Date: Wed, 23 May 2012 23:18:03 +0800
X-Google-Sender-Auth: 6AT0WkdBe0e5ozEJ7QNdbudKgHU
Message-ID: <CAF1ivSYTw19AEXmhAsvXp-vVk5ZGeFPzi9omBzCtYGKixNS5xw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:03 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 23 May 2012, Lin Ming wrote:
>
>> Another thing need to check is if system suspend/resume works.
>
> Right!  Although I would hope that your work doesn't interfere at all
> with system sleep, since it touches only the runtime PM pathways.

sd_sync_cache and sd_start_stop_device are changed with REQ_PM set.
And they are called for system suspend too.

So it probably will have problem.

>
> Alan Stern
