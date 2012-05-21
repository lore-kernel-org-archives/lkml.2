Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2EUOlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:41:47 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52769 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2EUOlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
References: <1337269686-3781-3-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Date: Mon, 21 May 2012 22:41:43 +0800
X-Google-Sender-Auth: iTgGO8HwkUKADaOppTX_dnKtROQ
Message-ID: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
[snip]
> I may have left some parts out from this brief description.  Hopefully
> you'll be able to figure out the general idea and get it to work.

All journal threads and flusher thread of the disk need to be freezed
before suspend and thaw after resume.

>
> Alan Stern
