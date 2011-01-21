Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1AUPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:09:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:46573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab1AUPJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:09:26 -0500
Date: Fri, 21 Jan 2011 16:09:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
In-Reply-To: <4D399DAB.3080808@signal11.us>
Message-ID: <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz>
References: <1295590785-7101-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz> <4D399DAB.3080808@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Alan Ott wrote:

> Maybe it is. To be honest I didn't check debugfs. I have two concerns about
> it:
> 1. Is it wise for userspace programs to rely on:

Ah, I didn't realize that you want it to be used by some acutal userspace 
applications. Out of curiosity -- what is the usage pattern you are 
targetting?

The idea behind debugfs-provided userspace descriptor is that driver 
developer is easily able to inspect the descriptor, and write a kernel 
driver that fixes it up in case it is bogus.
There were also efforts to make the report descriptor replaceable in a 
request_firmware() way, but that never converged to state in which it 
could be applied IIRC.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
