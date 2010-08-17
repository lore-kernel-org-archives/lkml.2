Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0HQPIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:08:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43142 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0HQPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tB7erpqcd42FAUA7TpqPDirrKy9FKZyyPQp9RMWg/dflbA9WxFiGkfO9YRIr6sFGca
         aNXQIe8LBs4n9CezLaKDmRR3+C6WNe+9AUGS21gggY2VQCLgYoc7L1c0rbwHy7/BnEL3
         LxxMK4KZrJThPJ/+AdKb5QWdigA2Bxk4RNSNw=
Message-ID: <4C6AA50F.3090801@gmail.com>
Date: Tue, 17 Aug 2010 17:04:47 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C6A6145.7020707@gmail.com> <201008171229.28917.stephan.diestelhorst@amd.com> <201008171251.29441.stephan.diestelhorst@amd.com>
In-Reply-To: <201008171251.29441.stephan.diestelhorst@amd.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 12:51 PM, Stephan Diestelhorst wrote:
> I *think* I have applied the patch correctly. Please find a copy of
> "git show" in the build directory attached. This should be the right
> thing, shouldn't it?

Yeah, looks right to me but if you have enabled IPM, there gotta be
at least some XXX messages in the log.  Weird.

> Maybe I forgot to speify a particular debug option / verbosity?

Hmmm... all messages are at KERN_INFO level and they don't have any
switch.

> I've also confirmed that the "XXX ahci_set_ipm" is present in
> libahci.ko. So either I've screwed up badly when compiling the initrd,
> the code is not executed or the printout does not make it into any
> logfile anymore.

Yeah, that's weird.  You're enabling IPM, right?

Thanks.

-- 
tejun
