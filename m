Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab1JYNYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:24:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:21713 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab1JYNYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:24:36 -0400
Message-ID: <4EA6B8BA.2030709@parallels.com>
Date: Tue, 25 Oct 2011 17:25:14 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v6 1/8] SUNRPC: introduce helpers for reference counted
 rpcbind clients
References: <20111025100826.12689.46944.stgit@localhost6.localdomain6>		 <20111025101608.12689.68689.stgit@localhost6.localdomain6>	 <1319541369.2716.1.camel@lade.trondhjem.org>	 <4EA6AE87.5000309@parallels.com> <1319546750.2716.5.camel@lade.trondhjem.org>
In-Reply-To: <1319546750.2716.5.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.10.2011 16:45, Trond Myklebust пишет:
>
> The empty 'return' at the end of a void function: it is 100%
> redundant...
>

O, yes, of course. Sorry.


-- 
Best regards,
Stanislav Kinsbursky
