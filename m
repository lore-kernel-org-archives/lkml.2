Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab2JaSo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:44:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59150 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab2JaSoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:44:55 -0400
Message-ID: <5091719D.9090109@zytor.com>
Date: Wed, 31 Oct 2012 11:44:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        x86 list <x86@kernel.org>
Subject: Re: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device
 and driver types
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <1825320.jYYkSTpTOm@vostro.rjw.lan> <20121031162407.GA318@kroah.com> <1587006.fly6qcnVo1@vostro.rjw.lan>
In-Reply-To: <1587006.fly6qcnVo1@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 11:42 AM, Rafael J. Wysocki wrote:
>
> Great, thanks!
>
> I wonder if the x86 and/or ia64 maintainers have any reservations?
>

None here.

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

