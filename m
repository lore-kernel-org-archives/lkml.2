Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0EFCD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:03:58 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:60518 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0EFCD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:03:57 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAObA4UurR7H+/2dsb2JhbACdYHGjNJlYhRMEgz4
X-IronPort-AV: E=Sophos;i="4.52,338,1270425600"; 
   d="scan'208";a="125422350"
User-Agent: Microsoft-Entourage/12.24.0.100205
Date: Wed, 05 May 2010 19:03:54 -0700
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
From: Scott Feldman <scofeldm@cisco.com>
To: Shreyas Bhatewara <sbhatewara@vmware.com>, Arnd Bergmann <arnd@arndb.de>,
       Dmitry Torokhov <dtor@vmware.com>
CC: Christoph Hellwig <hch@infradead.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       Pankaj Thakkar <pthakkar@vmware.com>
Message-ID: <C807719A.2E910%scofeldm@cisco.com>
Thread-Topic: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Thread-Index: AcrsnXZHfCzcBb5GR+COtROFMlz8vwAAIsdgAAiX7Gg=
In-Reply-To: <89E2752CFA8EC044846EB8499819134102AF2896F5@EXCH-MBX-4.vmware.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 06 May 2010 02:03:56.0366 (UTC) FILETIME=[627C26E0:01CAECC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/10 10:29 AM, "Dmitry Torokhov" <dtor@vmware.com> wrote:

> It would not be a binary blob but software properly released under GPL.
> The current plan is for the shell to enforce GPL requirement on the
> plugin code, similar to what module loaded does for regular kernel
> modules.

On 5/5/10 3:05 PM, "Shreyas Bhatewara" <sbhatewara@vmware.com> wrote:

> The plugin image is not linked against Linux kernel. It is OS agnostic infact
> (Eg. same plugin works for Linux and Windows VMs)

Are there any issues with injecting the GPL-licensed plug-in into the
Windows vmxnet3 NDIS driver?

-scott

