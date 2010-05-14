Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0ENDUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:20:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39424 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab0ENDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:20:10 -0400
X-Sasl-enc: LiN8Ki+ceHJyRZS4wmk/xoE3C5XiB2/fIekwvIWelHZK 1273807203
Date: Fri, 14 May 2010 00:20:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: huaxu.wan@intel.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2 V3] hwmon: (coretemp) Detect the
 thermal sensors by CPUID
Message-ID: <20100514032000.GB17786@khazad-dum.debian.net>
References: <20100507095459.GA12190@owl>
 <20100510033525.GC9181@owl>
 <20100511080112.GB19762@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511080112.GB19762@owl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Huaxu Wan wrote:
> +                       printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
> +                               " has no thermal sensor!\n", c->x86_model);

IMHO, it is better to drop that "!" since it is now a simple status message,
otherwise it still looks like there is something wrong with the CPU not
having a thermal sensor.

Minor thing, really, so feel free to ignore this comment.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
