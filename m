Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2JWO52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:57:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32935 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab2JWO51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:57:27 -0400
Message-ID: <5086B052.3030105@arm.com>
Date: Tue, 23 Oct 2012 15:57:22 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Kukjin Kim <kgene@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined
References: <022101cdb12d$724e9650$56ebc2f0$@org>
In-Reply-To: <022101cdb12d$724e9650$56ebc2f0$@org>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 23 Oct 2012 14:57:23.0435 (UTC) FILETIME=[B571ABB0:01CDB12E]
X-MC-Unique: 112102315572513101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/12 15:48, Kukjin Kim wrote:
> Hi all,
> 
> Now, v3.7-rc2 happens following build error with s3c2410_defconfig...
> 
> ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 
> Any idea on this?

This is becoming a recurring pattern...

Please see:
https://patchwork.kernel.org/patch/1570611/
https://lkml.org/lkml/2012/10/9/393

and probably a few other instances...

	M.
-- 
Jazz is not dead. It just smells funny...

