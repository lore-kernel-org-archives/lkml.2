Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1DDPiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:38:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26034 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1DDPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:38:07 -0400
Date: Mon, 4 Apr 2011 08:37:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: linux-next: Tree for April 4 (sound/soc)
Message-Id: <20110404083747.34ed1398.randy.dunlap@oracle.com>
In-Reply-To: <20110404143546.e2bb3379.sfr@canb.auug.org.au>
References: <20110404143546.e2bb3379.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D99E5D1.0046:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 14:35:46 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110401:


When CONFIG_SPI=n, CONFIG_I2C=n:

sound/soc/soc-cache.c:418: error: implicit declaration of function 'i2c_master_send'
sound/soc/soc-cache.c:421: error: implicit declaration of function 'do_spi_write'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
