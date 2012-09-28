Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab2I1Mqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:46:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45841 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab2I1Mqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:46:51 -0400
Date: Fri, 28 Sep 2012 15:46:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stephen Boyd <bebarino@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org
Subject: Re: rt73usb WARNING: at net/mac80211/driver-ops.h:12
 check_sdata_in_driver
Message-ID: <20120928124632.GG5368@mwanda>
References: <505AD51F.7050709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505AD51F.7050709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I have created a bug for this:
https://bugzilla.kernel.org/show_bug.cgi?id=48041

We only recently added the warning on that path.

Please add the following information.
*) Complete dmesg

regards,
dan carpenter
