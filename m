Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1CATgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:36:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49999 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab1CATgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s7aavmGaeAFIZO3shOLIR6Y5tn6vLfqtjsrDwmsa6rwy/N4DsxPuF6O+faxP3nhVgg
         b8FJBTKdJOTNK6xENt0bGw8yMUyxPcaf/okC8t9z6+3ecjQp73uyr68hY0MibpV5Bevj
         afv1Qx5nubrh8s0HwHnX3sOrXB+D9JUH7VRvk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1103011431400.2034-100000@iolanthe.rowland.org>
References: <cover.1298820825.git.tardyp@gmail.com>
	<Pine.LNX.4.44L0.1103011431400.2034-100000@iolanthe.rowland.org>
Date: Tue, 1 Mar 2011 20:36:48 +0100
Message-ID: <AANLkTi=ogThxB_2bxANV4hUsLGZs04gzHSCyH90Bm87U@mail.gmail.com>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
From: Pierre Tardy <tardyp@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 8:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 1 Mar 2011, Pierre Tardy wrote:
>
>> Please find sdhci runtime_pm implementation.
>>
>> It uses clock gating fw as a tip to know when our chip is idle.
>> It implements wake up from card insertion/removal.
>>
>> This is RFC, please dont merge yet. I really would like to have deep review
>> from PCI linux-pm guys.
>>
>> Opens are:
>>
>> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
>>  are not duplicate from what the core is doing.
>
> There may be one or two small errors.
>
>> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
>
> Other drivers do it, but they use PCI PME# instead of interrupts.
Could you please elaborate?
My understanding is that PCI PME will generate MSI, which translate in
interrupt.

Thanks
Pierre
