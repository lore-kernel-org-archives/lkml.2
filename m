Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2HWWSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 18:18:21 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54806 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754115Ab2HWWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 18:18:17 -0400
Message-ID: <5036AC23.8020309@xenotime.net>
Date: Thu, 23 Aug 2012 15:18:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: Build regressions/improvements in v3.6-rc3
References: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 01:46 PM, Geert Uytterhoeven wrote:

> *** ERRORS ***
> 
> 54 regressions:


>   + drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types for 'dump_mem':  => 56:6
>   + drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types for 'dump_mem':  => 134:6

Anyone see what causes this?  I looked but failed to see
the problem.



> *** WARNINGS ***
> 
> 6202 regressions:
>   + Documentation/watchdog/src/watchdog-test.c: warning: no previous prototype for 'term' [-Wmissing-prototypes]:  => 34:6


patch posted by me... not merged anywhere AFAIK.


>   + fs/pstore/ram.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'size_t' [-Wformat]:  => 409:3


patch posted by me.  Should be in the new linux-pstore.git tree.

-- 
~Randy
