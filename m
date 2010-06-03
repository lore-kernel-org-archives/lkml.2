Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0FCVU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0FCVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:20:26 -0400
Message-ID: <4C081B4A.4060801@redhat.com>
Date: Thu, 03 Jun 2010 17:14:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, mjg@redhat.com, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH]: x86: use acpi flags for apic mapping
References: <20100602192418.2706.35192.sendpatchset@prarit.bos.redhat.com> <20100602194956.GB5264@lenovo> <4C06D91F.2060105@redhat.com> <20100603172126.GA5502@lenovo> <4C07EF69.6050301@redhat.com> <4C0817CE.6050006@oracle.com>
In-Reply-To: <4C0817CE.6050006@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It seems we don't need this patch.
>
> so all system should support phys apic mode, but system with less 8 cpus is supposed to support cluster mode for better performance.
>
> current kernel will try to use cluster mode if nr_cpus is less than 8.
>
> some system have problem like IBM and NCR only support phys apic mode even cpus < 8 ...
>
>   

What about systems that have set the ACPI values?  We just ignore those
then?

P.

> Thanks
>
> Yinghai
>
>   
