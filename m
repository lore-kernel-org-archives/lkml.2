Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1BAKV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:21:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:59463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1BAKV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:21:27 -0500
Date: Tue, 1 Feb 2011 11:21:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hidraw: fixed hidraw_disconnect()
In-Reply-To: <1296263850.2299.11.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1102011121110.5725@pobox.suse.cz>
References: <1296263850.2299.11.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jan 2011, Stefan Achatz wrote:

> hidraw_disconnect() first sets an entry in hidraw_table to NULL
> and calls device_destroy() afterwards. The thereby called
> hidraw_release() tries to read this already cleared value resulting
> in never removing any device from the list.
> This got fixed by changing the order of events.

Applied, good catch. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
