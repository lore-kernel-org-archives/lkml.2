Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1EEJ0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:26:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42400 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1EEJ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:26:01 -0400
Date: Thu, 5 May 2011 14:55:55 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        kexec@lists.infradead.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] Kdump and memory error handling
Message-ID: <20110505092555.GA17414@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20110504193509.GA5342@in.ibm.com>
 <20110504203914.GC1737@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504203914.GC1737@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 10:39:14PM +0200, Andi Kleen wrote:
> Handle dumps of corrupted memory regresions:
> 
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/crashdump

What happens when mce is disabled and capture kernel reads corrupted memory? 
Does that result in dump having erroneous data in dump?

- vatsa
