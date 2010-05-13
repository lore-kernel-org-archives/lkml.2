Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141Ab0EMUJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:09:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33198 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0EMUJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:09:43 -0400
Message-ID: <4BEC5C6A.7040205@zytor.com>
Date: Thu, 13 May 2010 13:09:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Mike Habeck <habeck@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com> <4BEC5530.1000008@sgi.com> <201005131402.30759.bjorn.helgaas@hp.com>
In-Reply-To: <201005131402.30759.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 01:02 PM, Bjorn Helgaas wrote:
> 
> Yep, that's definitely a problem, and I don't have a good solution.
> 
> HP (and probably SGI) had a nice hardware solution for ia64 --
> address translation across the host bridge, so each bridge could
> have its own 64K I/O space.  But I don't see that coming in the
> x86 PC arena.
> 

I would agree, that is unlikely (not that I have any information on this
subject, mind you.)  Much more likely would be a bridge extension
capability for finer-grained I/O space routing.

	-hpa
