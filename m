Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1EQSQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:16:40 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:42312 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755920Ab1EQSQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:16:39 -0400
Date: Tue, 17 May 2011 20:05:18 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
 tristate options
Message-ID: <20110517180518.GC18699@game.jcrosoft.org>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13511924782779181897
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.500001/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:35 Tue 17 May     , Michal Marek wrote:
> For strings and integers, the config_is_xxx macros are useless and
> sometimes misleading:
except if the interger or hex can be at 0
so the config_is_ is usefull to known that it's enabled
> 
>   #define CONFIG_INITRAMFS_SOURCE ""
>   #define config_is_initramfs_source() 1
here agreed but I'm nor sure if it's a special case or if it will we the case
for most of the string

Best Regards,
J.
