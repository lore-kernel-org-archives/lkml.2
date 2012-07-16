Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2GPE5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 00:57:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59684 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GPE5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 00:57:37 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-f5-50039f2923d3
Message-id: <50039F24.60102@samsung.com>
Date: Mon, 16 Jul 2012 13:57:08 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the battery tree
References: <20120716140917.f780e8c3c7c74f1db1fed0ae@canb.auug.org.au>
In-reply-to: <20120716140917.f780e8c3c7c74f1db1fed0ae@canb.auug.org.au>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jAV3N+cwBBl/2KFhc3jWHzeLgwjZG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmXtnPXLCeveL8ue3MDYxz2boYOTkkBEwkjvavg7LF
	JC7cWw9kc3EICSxilNg8F8Z5ySjRPO0DexcjBwevgIbEl7veIA0sAqoSO07uA2tmE9CS2P/i
	BhtIiahAhMSvfg6QMK+AoMSPyfdYQMIiAtoSB34LgExkFjjAKPHk3nNWkBphATeJ/g1/2EFs
	ISD7xMS1TCA2p4C7xNsl+5hBbGYBHYn9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHIjPpHcwrmqwOMQowMGoxMO7oJQ5QIg1say4MvcQ
	owQHs5IIb2cnUIg3JbGyKrUoP76oNCe1+BCjNAeLkjivifdXfyGB9MSS1OzU1ILUIpgsEwen
	VAOjB+8ydp+qck+J17ueqt24UR9gOWtG3OWj/X73tt1nDDoTbLh0yaHbBsozmHTnz/1wuCSl
	a76c9lH53S695z6cuj1jnYmk4wO240ut661Kwx7bF92e4FP9WvJe3ZOv/RlL1CZzvGD9kr5L
	Krfva91Mr+duOzL7JwTGHIj5eO/n0oO3Zy9OOhC2QomlOCPRUIu5qDgRAIKPzNJAAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 07/16/2012 01:09 PM, Stephen Rothwell wrote:

> Hi Anton,
> 
> After merging the battery tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/built-in.o: In function `charger_manager_probe':
> charger-manager.c:(.text+0x11d61a): undefined reference to `extcon_register_interest'
> charger-manager.c:(.text+0x11d7b6): undefined reference to `extcon_unregister_interest'
> drivers/built-in.o: In function `charger_manager_remove':
> charger-manager.c:(.devexit.text+0x8f3): undefined reference to `extcon_unregister_interest'
> 
> Caused by commit bee737bccb03 ("charger-manager: Use EXTCON Subsystem to
> detect charger cables for charging").
> 
> I have used the battery tree from next-20120713 for today.


I'm so sorry, It is my mistake.
So, I resend below patch to fix build break of charger-manager.
- http://lkml.org/lkml/2012/7/16/5

Best Regards,
Chanwoo Choi
