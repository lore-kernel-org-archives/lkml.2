Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0IUCdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:33:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:41892 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0IUCdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:33:18 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2010 22:33:18 EDT
Date: Tue, 21 Sep 2010 10:21:12 +0800
From: liguozhu@huawei.com
Subject: Problem with debugfs
To: linux-kernel@vger.kernel.org
Message-id: <20100921022112.GA10336@localhost>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, there,

I do not know who is the maintainer for debugfs now. But I think there is
problem with its API: It uses filp->priv->mutex to protect the read/write (to
the file) for the value of its attribute, but the mutex is not exported to the
API user.  Therefore, there is no way to protect its value when you directly
use the value in your module.

Is my understanding correct?

Thanks


Best Regards
Kenneth Lee
