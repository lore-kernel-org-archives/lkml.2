Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2HNSBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:01:01 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:54223 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757115Ab2HNSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:00:57 -0400
Message-ID: <502A9200.1020606@xenotime.net>
Date: Tue, 14 Aug 2012 10:59:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 14 (drivers/input/touchscreen/edt-ft5x06.c)
References: <20120814135506.b6b86e3c8cb9da1eefb7bbd6@canb.auug.org.au>
In-Reply-To: <20120814135506.b6b86e3c8cb9da1eefb7bbd6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 08:55 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120813:
> 


on x86_64, when CONFIG_DEBUG_FS is not enabled:

drivers/input/touchscreen/edt-ft5x06.c: In function 'edt_ft5x06_ts_remove':
drivers/input/touchscreen/edt-ft5x06.c:846:14: error: 'struct edt_ft5x06_ts_data' has no member named 'raw_buffer'


-- 
~Randy
