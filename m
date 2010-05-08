Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0EHFzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 01:55:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60012 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab0EHFzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 01:55:05 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC - Cleaned up hypervisor layer
Date: Fri, 7 May 2010 22:54:10 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Hank Janssen <hjanssen@microsoft.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>
References: <4BE49778.6060800@zytor.com>
In-Reply-To: <4BE49778.6060800@zytor.com>
Organization: VMware, Inc.
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005072254.11578.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 May 2010 03:43:04 pm H. Peter Anvin wrote:
> @@ -82,24 +82,21 @@ void __init vmware_platform_setup(void)
> 
>   * serial key should be enough, as this will always have a VMware
>   * specific string when running under VMware hypervisor.
>   */
> 
> -int vmware_platform(void)
> +static bool __init vmware_platform(void)

This will break our balloon driver which uses vmware_platform() to detect
whether it should run or not.

Thanks.

-- 
Dmitry
