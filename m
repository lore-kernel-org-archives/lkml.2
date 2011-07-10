Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1GJIX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 04:23:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab1GJIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 04:23:25 -0400
Message-ID: <4E196175.2020307@gmail.com>
Date: Sun, 10 Jul 2011 09:23:17 +0100
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Hans-Peter Jansen <hpj@urpla.net>,
        Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, hooanon05@yahoo.co.jp,
        James Morris <jmorris@redhat.com>, Bruce Fields <bfields@redhat.com>,
        Steve Dickson <SteveD@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>	<20110608153208.dc705cda.akpm@linux-foundation.org>	<201107052154.32606.hpj@urpla.net> <87box52amy.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87box52amy.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 01:57 PM, Miklos Szeredi wrote:
> "Hans-Peter Jansen"<hpj@urpla.net>  writes:
>
>> All kodos to you, Miklos. While I'm still missing a major feature from
>> overlayfs that is a NFS as upper layer, it provides a fairly good
>> start. A commitment from you, that such an extension is considered for
>> inclusion - given, that it appears one day - is appreciated. Also,
>> since xattr support is available for NFS,
> AFAIK development of generic xattr support on NFS stopped some time ago.

Hi Miklos,

There is a proposed (at the IETF) standard called "labelled NFS" that would 
allow the protocol to handle xattrs.

It has not set the world on fire in terms of enthusiasm, but has been making 
some progress. We have patches from Dave Quigley that did work, but need to 
resolve the standards issues I suspect before it could make progress upstream...

Ric

>> it would be nice to outline, what is missing for such an
>> implementation from overlayfs's POV.
> Allow using namspace polluting xattr replacements, such as aufs is
> doing.
>
> But why?  Why is it better to do the overlaying on the client instead of
> the server?
>
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

