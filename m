Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1F2Wdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 18:33:44 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21670 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1F2Wdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 18:33:42 -0400
Message-ID: <4E0BA7FE.9050607@hp.com>
Date: Wed, 29 Jun 2011 16:32:30 -0600
From: sreenivasa reddy berahalli <sreenivasa-reddy-berahalli@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        yinghai@kernel.org, Feng Tang <feng.tang@linux.intel.com>,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: MPS table vs ACPI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

Recent interaction with BIOS teams within in my Organization left me
wondering if MP table spec from Intel is no more a mandatory one
http://www.intel.com/design/pentium/datashts/24201606.pdf

Section #8.4.5 http://www.intel.com/Assets/PDF/manual/253668.pdf
Talks as ACPI or MPS table.
That means BIOS can report through ACPI tables only.

I looked through x86 boot sequence and notice Linux scanning for MPS
table in below locations and Linux doesn't seem to go further without
MPS table or doesn't know how to live with ACPI only.
 1) Scan the bottom 1K for a signature
 2) Scan the top 1K of base RAM
 3) Scan the 64K of bios

Your insights into this topic are appreciated.

Thanks,
Sreenivas
