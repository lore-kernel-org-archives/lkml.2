Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2BUK4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:56:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab2BUK4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:56:34 -0500
Date: Tue, 21 Feb 2012 11:56:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Denis Kovalev <Denis.Kovalev@dataart.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: add support of Panasonic multitouch
 panels
In-Reply-To: <1329209433-8149-1-git-send-email-Denis.Kovalev@dataart.com>
Message-ID: <alpine.LNX.2.00.1202211155580.31150@pobox.suse.cz>
References: <1329209433-8149-1-git-send-email-Denis.Kovalev@dataart.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Denis Kovalev wrote:

> Signed-off-by: Denis Kovalev <Denis.Kovalev@dataart.com>
> ---
>  drivers/hid/Kconfig          |    1 +
>  drivers/hid/hid-core.c       |    2 ++
>  drivers/hid/hid-ids.h        |    6 +++++-
>  drivers/hid/hid-multitouch.c |   19 +++++++++++++++----
>  4 files changed, 23 insertions(+), 5 deletions(-)

Adjusted commit message, fixed a trivial conflict in multitouch branch 
(MT_CLS value needed to be changed) and applied, thanks Denis.

-- 
Jiri Kosina
SUSE Labs
