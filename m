Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1HEMsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:48:14 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:51512 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab1HEMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:48:11 -0400
X-AuditID: 1209190f-b7b44ae000000a24-76-4e3be5f3d45a
Message-ID: <4E3BE686.7070501@mit.edu>
Date: Fri, 05 Aug 2011 08:48:06 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "Yung, Winson W" <winson.w.yung@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Is there a way to offload everything from cpu0 to other cpus?
References: <CAC4B8726E86A142B27A9E9A2F2F124701922F2855@rrsmsx505.amr.corp.intel.com>
In-Reply-To: <CAC4B8726E86A142B27A9E9A2F2F124701922F2855@rrsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42IR4hTV1v381NrPYPshMYvLu+awWbQc3sPi
	wOSxeM9LJo/Pm+QCmKK4bFJSczLLUov07RK4MibPmc1YMIO5onfSRMYGxiNMXYwcHBICJhKb
	N2p1MXICmWISF+6tZ+ti5OIQEtjHKHF4/xcoZz2jxNLHq1ghnDdMEm+nN7CCtPAKqEks/rOa
	CcRmEVCVuDp1OjuIzSagItGx9AFYXFQgSOL+7wYWiHpBiZMzn4DZIgJ6EleOPmIDsZkFHCVu
	730LVi8s4CWxYMY+sOuEBEIlbn9UBwlzCoRJtLWeYwcJMwtYS3zbXQTRKS+x/e0c5gmMgrOQ
	LJiFUDULSdUCRuZVjLIpuVW6uYmZOcWpybrFyYl5ealFuiZ6uZkleqkppZsYwYEryb+D8dtB
	pUOMAhyMSjy8P3dZ+QmxJpYVV+YeYpTkYFIS5T31xNpPiC8pP6UyI7E4I76oNCe1+BCjBAez
	kgiv5B2gHG9KYmVValE+TEqag0VJnLfc+7+vkEB6YklqdmpqQWoRTFadg0Pg49uTIlIsefl5
	qUoSvKHAuBUSLEpNT61Iy8wpQahk4uAE2cMDtMcdpIa3uCAxtzgzHSJ/ilGXY/Xfj0cZhcAG
	SYnzyoIUCYAUZZTmwc2BpaFXjOJAHwpDrOMBpjC4Sa+AljABLfn/3gJkSUkiQkqqgVF8pv9N
	WfY1rtscFni+FDzQanyRi09oR8lUY8vNv1y+7Fzm1nOL2cz3f47SX21ft4VR6jv0Wzq1nBZd
	NOax+PpneerN8jTjdzf4ZM5lGbY160rfFWaw9m0/+Fv50vzlj9W+ez/kmpz264B72OydFydN
	Ep64+P/uB1/WPCpOdvy3vr3/3H6Fa2xKLMUZiYZazEXFiQBihu9lHgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 10:53 PM, Yung, Winson W wrote:
> Hi, I would like to know whether it is possible to offload everything (kernel threads/user apps) to cpu1...x so that I can force cpu0 go into idle?
>
> I can affinity all the interrupt to a different cpu by playing with the /proc/irq/irqx/smp_affinity, how about everything else?
>

You probably want the isolcpus boot option.

--Andy

> /Winson.

