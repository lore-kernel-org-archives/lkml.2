Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0HSUhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:37:51 -0400
Received: from mail.perches.com ([173.55.12.10]:1195 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0HSUhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:37:48 -0400
Subject: Re: pull request: wireless-2.6 2010-08-19
From: Joe Perches <joe@perches.com>
To: Jan III Sobieski <jan3sobi3ski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikDB2t+ZfcvsSJsw=OMnaR-_3ieG7zcmJjt=mH6@mail.gmail.com>
References: <20100819174638.GC2672@tuxdriver.com>
	 <AANLkTi=QmVT_qJb6O7eDE9-VM5CZBa3ueR9njFps5oMs@mail.gmail.com>
	 <1282243187.6724.250.camel@Joe-Laptop>
	 <AANLkTikDB2t+ZfcvsSJsw=OMnaR-_3ieG7zcmJjt=mH6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 13:37:46 -0700
Message-ID: <1282250266.6724.270.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 22:08 +0200, Jan III Sobieski wrote:
> I really like the new Linus policy - merge window is closed - only bug
> fixes are admitted.

This patch fixes a defect introduced during the merge window.

Some of the logging messages used %pM to emit a MAC address.

%pM outputs "xx:xx:xx:xx:xx:xx"
%pm output "xxxxxxxxxxxx"

When the message forms were standardized,
strings were lower cased, introducing this defect.

> IMHO this policy will result in a significant
> increase in stability.

There have been previous discussions on stability
vs change.

I think it's unnecessary to rehash them.

cheers, Joe

