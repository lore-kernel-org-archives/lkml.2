Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2JHTeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:34:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JHTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:34:17 -0400
Date: Mon, 8 Oct 2012 16:34:10 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>
Subject: Re: [ 068/108] HID: hidraw: add proper error handling to raw event
 reporting
Message-ID: <20121008193409.GC3004@herton-Z68MA-D2H-B3>
References: <20121007225834.673681075@decadent.org.uk>
 <20121007225844.105600523@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007225844.105600523@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 11:59:42PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> commit b6787242f32700377d3da3b8d788ab3928bab849 upstream.
> 
> If kmemdup() in hidraw_report_event() fails, we are not propagating
> this fact properly.
> 
> Let hidraw_report_event() and hid_report_raw_event() return an error
> value to the caller.

This needs in addition a small fix on top, commit d6d7c87
("HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW")

-- 
[]'s
Herton
