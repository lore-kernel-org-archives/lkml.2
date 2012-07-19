Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2GSWc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:32:56 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14465 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2GSWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:32:53 -0400
Message-ID: <1342737168.6809.40.camel@lorien2>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        shuahkhan@gmail.com
Date: Thu, 19 Jul 2012 16:32:48 -0600
In-Reply-To: <1342731093.3010.245.camel@misato.fc.hp.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342648771.5138.37.camel@lorien2>
	 <1342650386.3010.55.camel@misato.fc.hp.com>
	 <1342651257.5138.44.camel@lorien2>
	 <1342651966.3010.66.camel@misato.fc.hp.com>
	 <1342653482.5138.56.camel@lorien2>
	 <1342658296.3010.136.camel@misato.fc.hp.com>
	 <1342714515.3100.27.camel@lorien2>
	 <1342718897.3010.188.camel@misato.fc.hp.com>
	 <1342725950.5599.7.camel@lorien2>
	 <1342731093.3010.245.camel@misato.fc.hp.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 14:51 -0600, Toshi Kani wrote:

> If your concern is actually a performance bottleneck in acpi_get_name()
> you found in the code, you should report it to the ACPI CA team.

I have tried my best to get you to understand the problems in bigger
picture your patch set can exacerbate. Looking to somebody else to fix
the problems doesn't help. It doesn't look like we can come to an
agreement here, we just have to agree to disagree.

caio,
-- Shuah

