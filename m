Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab1IGXVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:21:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64183 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1IGXVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:21:10 -0400
Date: Wed, 7 Sep 2011 16:21:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Michael Hennerich <michael.hennerich@analog.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Axel Lin <axel.lin@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khc@pm.waw.pl>,
        Julia Lawall <julia@diku.dk>,
        Sylvestre Ledru <sylvestre.ledru@scilab.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Paul Mundt <lethal@linux-sh.org>, Tejun Heo <tj@kernel.org>,
        device-drivers-devel@blackfin.uclinux.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 38/62] Input: irq: Remove IRQF_DISABLED
Message-ID: <20110907232101.GA32566@core.coreip.homeip.net>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-39-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-39-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:10:35PM +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 

Applied, thanks Yong.

-- 
Dmitry
