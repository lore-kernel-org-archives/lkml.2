Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1IXFYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 01:24:32 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41682 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1IXFYb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 01:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <35343.1316816580@turing-police.cc.vt.edu>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
	<35343.1316816580@turing-police.cc.vt.edu>
Date: Sat, 24 Sep 2011 10:54:29 +0530
Message-ID: <CA+mksuDD=7Zf1bhmdq_Ficz_ZQEdiE5GLOGH18Cgf+XEmCd74w@mail.gmail.com>
Subject: Re: [PATCHv9 00/18] omap PRCM chain handler
From: "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
To: Valdis.Kletnieks@vt.edu
Cc: Tero Kristo <t-kristo@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis.Kletnieks,

On Sat, Sep 24, 2011 at 3:53 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 23 Sep 2011 15:46:08 +0300, Tero Kristo said:
>> Following set contains the version 9 of this work. This patch set contains
>> a number of patches tagged as 'TEMP', they are only meant for testing
>> purposes and to provide proof of concept. Most of the 'TEMP' patches are
>> related to UART runtime handling and they will be replaced by work done
>> by Govindraj Raja.
>
> What do we do with these TEMP patches if the UART patches don't make the same
> merge window, or have other issues?  I'm always leery of "will be replaced"
> code, because I've seen too many times when it *didn't* get replaced.
>
> (I really don't care what the 'Plan B' is, as long as we have one...)
UART Runtime patches are already posted for review and it's also
targeted for next merge window. Our intention is to push both the
features together for next merge window.

Regards
Vishwa

>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
