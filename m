Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab0HOPgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0HOPge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:36:34 -0400
Message-ID: <4C67D074.6080107@redhat.com>
Date: Sun, 15 Aug 2010 14:33:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: Tom Lyon <pugs@cisco.com>, mst@redhat.com, hjk@linutronix.de,
        gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: UIO DMA to userspace question
References: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
In-Reply-To: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/07/2010 09:38 PM, Leon Woestenberg wrote:
> Hello all,
>
> can I use the UIO framework for the following?
>
> The userspace portion of the driver allocates memory in user-space
> using malloc() - usually resulting in a scatter pages in physical
> memory.
> The UIO kernel portion of the driver maps those using pci_map_sg().
>
> Is this possible, or does the UIO framework assume memory for DMA is
> allocated in kernel space?

Look at the new VFIO driver, which can do DMA if you have an IOMMU.

-- 
error compiling committee.c: too many arguments to function

