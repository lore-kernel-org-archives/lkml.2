Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1DKC5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 22:57:25 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:39585 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752138Ab1DKC5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 22:57:24 -0400
Date: Mon, 11 Apr 2011 04:45:59 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: wanlong.gao@gmail.com
Cc: linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, mingo@elte.hu, rientjes@google.com,
        nicolas.ferre@atmel.com, eric@eukrea.com, tony@atomide.com,
        santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        ben-linux@fluff.org, sam@ravnborg.org, manuel.lauss@googlemail.com,
        galak@kernel.crashing.org, anton@samba.org, grant.likely@secretlab.ca,
        sfr@canb.auug.org.au, jwboyer@linux.vnet.ibm.com,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] fix build warnings on defconfigs
Message-ID: <20110411024559.GB18925@game.jcrosoft.org>
References: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7876232800264039283
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03:04 Sun 10 Apr     , wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Change the BT_L2CAP and BT_SCO defconfigs from 'm' to 'y',
> since BT_L2CAP and BT_SCO had changed to bool configs.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
for at91
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
