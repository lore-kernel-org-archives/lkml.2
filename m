Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1F3VGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:06:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:23928 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1F3VGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:06:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,454,1304319600"; 
   d="scan'208";a="20287285"
User-Agent: Microsoft-MacOutlook/14.12.0.110505
Date: Thu, 30 Jun 2011 14:06:39 -0700
Subject: Re: [PATCH v7 00/16] EVM 
From: Ryan Ware <ware@linux.intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Message-ID: <CA323325.7D40%ryan.r.ware@intel.com>
Thread-Topic: [PATCH v7 00/16] EVM 
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glad to see this going in Mimi!  Looking forward to enabling this in our
MeeGo kernels.

Ryan

On 6/29/11 12:50 PM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:

>Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
>protect the integrity of a running system from unauthorized changes. When
>these protections are not running, such as when booting a malicious OS,
>mounting the disk under a different operating system, or physically moving
>the disk to another system, an "offline" attack is free to read and write
>file data/metadata.
>
>...snip...


