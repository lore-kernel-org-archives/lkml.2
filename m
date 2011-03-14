Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1CNB7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:59:04 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46176 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1CNB7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:59:02 -0400
Message-ID: <10d164106e8d30b89d7263b067db01f0.squirrel@webmail.greenhost.nl>
In-Reply-To: <4D7D7325.2040708@garzik.org>
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
    <4D7D7325.2040708@garzik.org>
Date: Mon, 14 Mar 2011 02:59:00 +0100 (CET)
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
X-Spam-Score: -0.6
X-Scan-Signature: 7194f67edb0fd0030ea28d62f3968513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, March 14, 2011 02:45, Jeff Garzik wrote:
> On 03/13/2011 09:31 PM, Indan Zupancic wrote:
>> The new syscall works on only one fd too. The behaviour of the proposed
>> syncfs and an extended sync_file_range is exactly the same.
>
> No, it's not.  You should read the patch before commenting.

Have you read my sync_file_range patch? Because it's exactly the
same code, but put in sync_file_range instead of a new system call.
How that can have different behaviour, I have no idea.


