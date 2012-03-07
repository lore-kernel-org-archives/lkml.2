Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2CGIgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:36:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23218 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2CGIgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:36:54 -0500
Message-ID: <4F571E0B.9060600@parallels.com>
Date: Wed, 07 Mar 2012 12:36:27 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] SUNRPC: set desired file system root before connecting
 local transports
References: <20120229145915.24030.31551.stgit@localhost6.localdomain6>	 <1331079588.10560.55.camel@lade.trondhjem.org> <1331079707.10560.56.camel@lade.trondhjem.org>
In-Reply-To: <1331079707.10560.56.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.03.2012 04:21, Myklebust, Trond пишет:
> BTW: We will in any case need Al Viro and Christoph's ACK in order to
> export the set_fs_root() function.

Yep, you right.
Is it better to add them into recipients on a reply to the patch or send the 
patch once more?

-- 
Best regards,
Stanislav Kinsbursky
