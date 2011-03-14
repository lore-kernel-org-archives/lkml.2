Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1CNBrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:47:55 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:51396 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1CNBrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:47:53 -0400
Message-ID: <49b3cf559f9a26a84b6d7f65b38364b9.squirrel@webmail.greenhost.nl>
In-Reply-To: <FB72B156-6DF9-413B-98F2-D23A449E9303@mit.edu>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <4D7AC0FE.8070806@gmail.com>
    <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
    <4D7ADFDD.9080108@gmail.com>
    <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
    <4D7BBC03.3020404@garzik.org>
    <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
    <FB72B156-6DF9-413B-98F2-D23A449E9303@mit.edu>
Date: Mon, 14 Mar 2011 02:47:48 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: "Theodore Tso" <tytso@MIT.EDU>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Ric Wheeler" <ricwheeler@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>, "Sage Weil" <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Jonathan Nieder" <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: c74461a82029b6293650421ecb57b64a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, March 14, 2011 02:37, Theodore Tso wrote:
>
> On Mar 13, 2011, at 9:31 PM, Indan Zupancic wrote:
>
>> The new syscall works on only one fd too. The behaviour of the proposed
>> syncfs and an extended sync_file_range is exactly the same.
>
> No, it's quite different.   One syncs the entire file system; sync_file_range
> requests that the pages associated with a file be pushed to disk --- it says
> nothing about the metadata associated with the file.

You missed the part where a new flag for sync_file_range would be added that
does sync the whole file system.

> I'm in favor of the new sys_syncfs system call.

Care to define its behaviour? Does it wait till all data is written out,
does it flush disk caches, what if new data is written to the fs while
a sync is going on, etc.

Greetings,

Indan


