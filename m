Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1DZI6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:58:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:36908 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1DZI6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:58:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="634155780"
Date: Tue, 26 Apr 2011 10:57:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 02/14] input: touchscreen: move initialization in
 88pm860x
Message-ID: <20110426085744.GA2659@sortiz-mobl>
References: <2011041801>
 <1303135451-26362-3-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-3-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Apr 18, 2011 at 10:03:59PM +0800, Haojian Zhuang wrote:
> Move the GPADC initialization code from mfd driver to touch driver.
I think this should go through Dmitry's tree. If he's ok with that:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
