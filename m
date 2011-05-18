Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1ERTnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:43:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57824 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752659Ab1ERTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:43:17 -0400
Date: Wed, 18 May 2011 12:43:12 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH -next] regulator: fix 88pm8607.c printk format warning
Message-ID: <20110518194311.GB5077@opensource.wolfsonmicro.com>
References: <20110518145412.f6cba4ef.sfr@canb.auug.org.au>
 <20110518100722.76bd6fb6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518100722.76bd6fb6.randy.dunlap@oracle.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:07:22AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warning (seen on x86_64) and change to unsigned
> output format:
> 
> drivers/regulator/88pm8607.c:417: warning: format '%d' expects type 'int', but argument 3 has type 'resource_size_t'

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
