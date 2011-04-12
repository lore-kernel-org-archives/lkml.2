Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab1DLSe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:34:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46345 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1DLSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SjVhy/O1l2xtewBR7RszmfMk/T5VLAkucM7EBhXfw8iSd/xDW1y0bBwbpFZpaxC90o
         S7t10PByRVTcVFfv5kgmkgIqOT98uNnJI6nyadDZGZkYPiZTnoZESPjhB51aoRGMww+1
         UXP2Wp3lL1+srH8GLon77SUVyzRwDtU2HQ4zc=
Message-ID: <4DA49B49.1020005@suse.cz>
Date: Tue, 12 Apr 2011 20:34:49 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Bryan Schumaker <bjschuma@netapp.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, ML netdev <netdev@vger.kernel.org>,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix infinite loop in gss_create_upcall()
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>	 <4D96E4C5.2080302@suse.cz> <1302122693.16786.0.camel@lade.trondhjem.org>	 <4D9D5CC9.2040002@suse.cz> <4DA36722.2020402@suse.cz>	 <4DA36758.4070203@suse.cz> <4DA36DB6.8060108@suse.cz>	 <4DA48EB0.40600@netapp.com>  <4DA4946D.5020403@suse.cz> <1302633088.4801.48.camel@lade.trondhjem.org>
In-Reply-To: <1302633088.4801.48.camel@lade.trondhjem.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 08:31 PM, Trond Myklebust wrote:
>> Yes, it fixes the problem. But it waits 15s before it times out. This is
>> inacceptable for automounted NFS dirs.
> 
> I'm still confused as to why you are hitting it at all. In the normal
> autonegotiation case, the client should be trying to use AUTH_SYS first
> and then trying rpcsec_gss if and only if that fails.
> 
> Are you really exporting a filesystem using AUTH_NULL as the only
> supported flavour?

I don't know, I connect to a nfs server which is not maintained by me.
It looks like that. How can I find out?

thanks,
-- 
js
suse labs
