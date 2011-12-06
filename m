Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab1LFMqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:46:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14847 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177Ab1LFMqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:46:54 -0500
Message-ID: <4EDE0E29.9030804@parallels.com>
Date: Tue, 06 Dec 2011 16:44:25 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jim Rees <rees@umich.edu>
CC: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] SUNRPC: create svc_xprt in proper network namespace
References: <20111206101910.1878.21798.stgit@localhost6.localdomain6> <20111206124427.GA12890@umich.edu>
In-Reply-To: <20111206124427.GA12890@umich.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

06.12.2011 16:44, Jim Rees пишет:
> Stanislav Kinsbursky wrote:
>
>    This patch makes svc_xprt inherit network namespace link from it's socket.
>
> Should be "its socket."

Yep, sure. Silly mistake.
Thanks.

-- 
Best regards,
Stanislav Kinsbursky
