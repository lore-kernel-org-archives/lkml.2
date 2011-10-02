Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1JBJFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 05:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1JBJFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 05:05:14 -0400
Message-ID: <4E88293E.5050006@redhat.com>
Date: Sun, 02 Oct 2011 11:05:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu >> \"Liu, Jinsong\"" <jinsong.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH] KVM: x86: Use do_div for tsc deadline calculation
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au> <4E84CC00.8090702@xenotime.net> <20110930085810.11bc8e2e38e1400a8b0b4cec@canb.auug.org.au> <4E85ACFC.1090509@siemens.com>
In-Reply-To: <4E85ACFC.1090509@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 02:50 PM, Jan Kiszka wrote:
> Required on i386 hosts.
>
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

