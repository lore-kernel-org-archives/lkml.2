Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab1JDU4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:56:06 -0400
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:40928
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933506Ab1JDU4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:56:05 -0400
Date: Tue, 4 Oct 2011 21:55:37 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Wang <qi.wang@intel.com>, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Message-ID: <20111004205536.GA13323@freya.fluff.org>
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 04:51:45PM +0900, Tomoya MORINAGA wrote:
> Linux I2C core doesn't support 10bit access formally.
> Additionally, we can't test with 10bit mode.
> This patch deletes the 10bit access processing.

do we want to keep this patch in the series? if not, can
you post a new series with this dropped from it?

-- 
Ben

