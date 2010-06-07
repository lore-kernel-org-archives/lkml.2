Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0FGDRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:17:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61022 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0FGDRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=SGOC++VMco7Dq2TqxHL/O94uMjRzDn+LiVArYZSRhHYKn6P9Mo5XhWxgZtiDVYp+TZ
         BysHAVXE1lA8VV7Rgt1L99HJUinPWkaTVjQXSTblBciyR5hYNG4BrKyQd/YZ8iIN++Zw
         iPNz6VuzH6uPS2IV20cKxTX2VRqnqMIBX4UwA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLvHu98TuIbZkuRnfiwUNz2HXI2cS_3EtKFSGo@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
	<AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
	<AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
	<AANLkTilAzIGdPGnZfi0y5fUpJm_J9pO_ns2cZhSFfMWh@mail.gmail.com>
	<AANLkTinpJfxgCxiPFpzcxShitSSn9VwZ-rUz2wQz6FKS@mail.gmail.com>
	<AANLkTinLvHu98TuIbZkuRnfiwUNz2HXI2cS_3EtKFSGo@mail.gmail.com>
Date: Mon, 7 Jun 2010 11:17:16 +0800
Message-ID: <AANLkTilWwN4wGwpf04xZD0s3BmGlgcJTTYMKxclobNzP@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Dave Airlie <airlied@gmail.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 11:07 AM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> Jeff -
>
> registers with 0720 patterns in all your cases.
>
> The vt.c patch has been reported to fix such issues in at least 3
>  distinct cases :)

Cool. I'll patch my kernel now.

Thanks,
Jeff
