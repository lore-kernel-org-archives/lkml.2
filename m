Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2GWNoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:44:46 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:62642 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753040Ab2GWNoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:44:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFAE9UDVBbdWOb/2dsb2JhbABFhSu0C4EHgiABAQUyAQUdIwEQCw4KCRYPCQMCAQIBRQYNAQcBAYgNvUyLTYZTA5VJhVuKMoJh
X-IronPort-AV: E=Sophos;i="4.77,639,1336341600"; 
   d="scan'208";a="547840957"
Message-ID: <500D5549.3040109@igalia.com>
Date: Mon, 23 Jul 2012 15:44:41 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, don@syst.com.br,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] classmate-laptop: Add support for Classmate V4
 accelerometer.
References: <cover.1340976795.git.magomez@igalia.com> <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com> <20120717224749.GA20813@nautilus.holoscopio.com> <5006BFEC.1010407@igalia.com> <20120723132841.GD21495@srcf.ucam.org> <500D52A7.8040606@igalia.com> <20120723133618.GC21838@srcf.ucam.org>
In-Reply-To: <20120723133618.GC21838@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 23/07/12 15:36, Matthew Garrett escribió:
> On Mon, Jul 23, 2012 at 03:33:27PM +0200, Miguel Gómez wrote:
>
>> Names are upper-cased in acpica, so the device is reported as
>> FNBT0000. But in the driver it's named FnBT0000, and that's why it
>> doesn't match.
>
> So just change the existing entry in the driver to FNBT0000?

I'd go for it. I can send a patch if you want. But not sure about 
Thadeu's opinion. In the old thread it seems that he wanted to explore 
other options besides that.

Do you agree with that change Thadeu?


-- 
Miguel Gómez
Igalia - http://www.igalia.com
