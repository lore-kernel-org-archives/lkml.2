Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab1CNBcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:32:15 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45307 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab1CNBcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:32:12 -0400
Message-ID: <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
In-Reply-To: <4D7BBC03.3020404@garzik.org>
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
Date: Mon, 14 Mar 2011 02:31:49 +0100 (CET)
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: "Indan Zupancic" <indan@nul.nu>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "Ric Wheeler" <ricwheeler@gmail.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "Sage Weil" <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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
X-Scan-Signature: 523f42b60907f92a5b98f162865e3e4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, March 12, 2011 19:31, Jeff Garzik wrote:
> On 03/11/2011 10:50 PM, Indan Zupancic wrote:
>> If sync(2) didn't exist and people wanted to add it I'd complain too. This
>> has all the problems of sync(2), but with the "not sure if all the files are
>> on the file system I think" problem added.
>
> You are decades too late, then...

I know.

> sync_file_range() is not appropriate because that works on only one fd.
>
> The new syscall is fine, and addresses a need.

The new syscall works on only one fd too. The behaviour of the proposed
syncfs and an extended sync_file_range is exactly the same.

Greetings,

Indan


