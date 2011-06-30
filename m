Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1F3AnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 20:43:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21710 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1F3Am4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 20:42:56 -0400
References: <4E0BA7FE.9050607@hp.com>
In-Reply-To: <4E0BA7FE.9050607@hp.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C8998C1F-0C0B-4B82-841A-16FD6829A90C@kernel.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Feng Tang <feng.tang@linux.intel.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8C148)
From: Yinghai <yinghai@kernel.org>
Subject: Re: MPS table vs ACPI
Date: Wed, 29 Jun 2011 17:40:37 -0700
To: sreenivasa reddy berahalli <sreenivasa-reddy-berahalli@hp.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E0BC61A.010D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Jun 29, 2011, at 3:32 PM, sreenivasa reddy berahalli <sreenivasa-reddy-berahalli@hp.com> wrote:

> Hello All,
> 
> Recent interaction with BIOS teams within in my Organization left me
> wondering if MP table spec from Intel is no more a mandatory one
> http://www.intel.com/design/pentium/datashts/24201606.pdf
> 
> Section #8.4.5 http://www.intel.com/Assets/PDF/manual/253668.pdf
> Talks as ACPI or MPS table.
> That means BIOS can report through ACPI tables only.
> 
> I looked through x86 boot sequence and notice Linux scanning for MPS
> table in below locations and Linux doesn't seem to go further without
> MPS table or doesn't know how to live with ACPI only.
> 1) Scan the bottom 1K for a signature
> 2) Scan the top 1K of base RAM
> 3) Scan the 64K of bios

Have one system with x2apic pre-enabled in bios, and it does not have mps table from bios. At least 2.6.32 based distribution kernel works well.
Current kernel works well too if you have acpi enabled in kernel.

Mptable assume apicid is 8 bits

Thanks

Yinghai