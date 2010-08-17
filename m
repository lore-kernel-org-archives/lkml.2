Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0HQV3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:29:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38583 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0HQV27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SZOSurYVrLJ3uUFal6NHG9FUEU3+wWtcdJk9akaGvW6G6A+0xG4lq/AgtTX8UQe732
         4T3/WGIWiv9Yv7DPfpdIVCvm/lfAodRZQIx615st6lSfARVdk/+GlxFE6l1520+rnfmy
         7c1onhnEFthptoPM5o0/YdbaZmwnisfnDgbgY=
MIME-Version: 1.0
In-Reply-To: <4C6AA50F.3090801@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com>
	<4C6A6145.7020707@gmail.com>
	<201008171229.28917.stephan.diestelhorst@amd.com>
	<201008171251.29441.stephan.diestelhorst@amd.com>
	<4C6AA50F.3090801@gmail.com>
Date: Tue, 17 Aug 2010 23:28:58 +0200
Message-ID: <AANLkTin2XPHXL_o9hHz9f4beTYEx+isX+PaFRkMMiYHQ@mail.gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
From: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        stephan.diestelhorst@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/8/17 Tejun Heo <htejun@gmail.com>:
> On 08/17/2010 12:51 PM, Stephan Diestelhorst wrote:
>> I *think* I have applied the patch correctly. Please find a copy of
>> "git show" in the build directory attached. This should be the right
>> thing, shouldn't it?
>
>> Maybe I forgot to speify a particular debug option / verbosity?
>
>> I've also confirmed that the "XXX ahci_set_ipm" is present in
>> libahci.ko. So either I've screwed up badly when compiling the initrd,
>> the code is not executed or the printout does not make it into any
>> logfile anymore.
>
> Yeah, that's weird.  You're enabling IPM, right?

Erm... Honestly, I have no clue. What is IPM? How do I enable it? This is a
Kubuntu Lucid 10.04 distribution, and I have not touched too much. In
particular, the kernels have been from upstream git, just with the Ubuntu config
copied over.

Maybe it is just not enabled? I am guessing that IPM might be IDE power
management? Or intelligent, integrated? Google turns up this email thread
as one of the first hits and nothing else conclusive.

Thanks,
  Stephan
