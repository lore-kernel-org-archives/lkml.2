Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab1FPS3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:29:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab1FPS3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:29:32 -0400
Message-ID: <4DFA4B1E.5020503@redhat.com>
Date: Thu, 16 Jun 2011 14:27:42 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>,
        David Howells <dhowells@redhat.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>	<20110608153208.dc705cda.akpm@linux-foundation.org>	<20110609115934.3c53f78f@notabene.brown>	<20110608205233.ebfedc4d.akpm@linux-foundation.org>	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>	<20110609123843.77153b27.akpm@linux-foundation.org>	<877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl> <m2r572f2wk.fsf@gmail.com>
In-Reply-To: <m2r572f2wk.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 05:31 AM, Francis Moreau wrote:
> "J. R. Okajima"<hooanon05@yahoo.co.jp>  writes:
>
> [...]
>
>> Aufs was rejected merging because LKML people decided that linux
>> mainline will never include the union-type-filesystem but will include
>> the union-type-mount (eg. UnionMount).
> BTW, what is the current status of the union mount approach ?
>
> Thanks

Val has moved on to other projects, but David Howells has been working to 
refresh the union mount patches and post them upstream. Al and Christoph have 
been looking at the patches.

I think that it would be good to get those patches out so people can do a full 
comparison.

Thanks!

Ric

