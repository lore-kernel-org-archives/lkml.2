Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0EMUfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:35:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54860 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab0EMUfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:35:04 -0400
Message-ID: <4BEC625D.4040700@zytor.com>
Date: Thu, 13 May 2010 13:34:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: Mike Habeck <habeck@sgi.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com> <4BEC5530.1000008@sgi.com> <4BEC62EB.3050803@oracle.com>
In-Reply-To: <4BEC62EB.3050803@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 01:36 PM, Yinghai Lu wrote:
> 
> mmio range should be much better, it could use mmio64
> 

We're not talking about MMIO.

	-hpa
