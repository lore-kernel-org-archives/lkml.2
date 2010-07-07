Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0GGGPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:15:41 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36326 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0GGGPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:15:40 -0400
Date: Wed, 7 Jul 2010 07:40:19 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2] panasonic-laptop: fix acpi_pcc_write_sset return
 value
Message-ID: <20100707054019.GM23331@prithivi.gnumonks.org>
References: <1278462108.12801.23.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278462108.12801.23.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 08:21:48AM +0800, Axel Lin wrote:
> In current implementation, acpi_pcc_write_sset return 1
> if write is successful, 0 if write is failed.
> But all the callers consider acpi_pcc_write_sset return 0
> if write is successful and return negtive if write is failed.
> 
> This patch changes the implementation of acpi_pcc_write_sset to
> return 0 if write is successful, -EIO if write is failed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-By: Harald Welte <laforge@gnumonks.org>
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
