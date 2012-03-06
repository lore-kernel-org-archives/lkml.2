Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133Ab2CFSvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:51:22 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:46488 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965074Ab2CFSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:51:20 -0500
Message-ID: <4F565CB0.8070301@xenotime.net>
Date: Tue, 06 Mar 2012 10:51:28 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 6 (staging/iio)
References: <20120306180746.25c595babf8b5072366cdbec@canb.auug.org.au>
In-Reply-To: <20120306180746.25c595babf8b5072366cdbec@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 11:07 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120305:


When CONFIG_DEBUG_FS is not enabled:

drivers/staging/iio/industrialio-core.c:621:11: error: 'iio_read_channel_ext_info' undeclared (first use in this function)
drivers/staging/iio/industrialio-core.c:623:11: error: 'iio_write_channel_ext_info' undeclared (first use in this function)




-- 
~Randy
