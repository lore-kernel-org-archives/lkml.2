Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828Ab2GLNlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:41:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52583 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933758Ab2GLNlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:41:16 -0400
Message-ID: <4FFED3CE.7030108@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 06:40:30 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: [RFC PATCH v3 3/13] memory-hotplug : unify argument of firmware_map_add_early/hotplug
References: <4FFAB0A2.8070304@jp.fujitsu.com> <4FFAB17F.2090209@jp.fujitsu.com> <4FFD9C08.2070502@linux.vnet.ibm.com> <4FFE5816.6070102@jp.fujitsu.com>
In-Reply-To: <4FFE5816.6070102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071213-3534-0000-0000-00000A5FCFD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 09:52 PM, Yasuaki Ishimatsu wrote:
> Does the following patch include your comment? If O.K., I will separate
> the patch from the series and send it for bug fix.

Looks sane to me.  It does now mean that the calling conventions for
some of the other firmware_map*() functions are different, but I think
that's OK since they're only used internally to memmap.c.

