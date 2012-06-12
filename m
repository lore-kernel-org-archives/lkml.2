Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2FLTBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:01:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44509 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab2FLTBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:01:06 -0400
Message-ID: <4FD791D6.5050503@zytor.com>
Date: Tue, 12 Jun 2012 12:00:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kent Yoder <shpedoikal@gmail.com>
CC: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>,
        "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "Cihula, Joseph" <joseph.cihula@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/2] driver: add PPI support in tpm driver
References: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com> <CAM0nabHV6CepQyXeVZiv2XT9WHPgMy=prdK-8fNgyrCZ4v6dSg@mail.gmail.com>
In-Reply-To: <CAM0nabHV6CepQyXeVZiv2XT9WHPgMy=prdK-8fNgyrCZ4v6dSg@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 11:57 AM, Kent Yoder wrote:
> 
>   This code looks clean - my only suggestion would be to add an #ifdef
> CONFIG_ACPI around it so it compiles out on ppc.
> 

Better yet, any way to separate it out in a separate source file?

	-hpa


