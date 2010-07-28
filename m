Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0G1Rr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:47:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33900 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab0G1Rr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:47:27 -0400
Date: Wed, 28 Jul 2010 10:46:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 13/13] AppArmor: update Maintainer and
 Documentation/kernel-parameters.txt
Message-Id: <20100728104629.ddba3cc5.randy.dunlap@oracle.com>
In-Reply-To: <1280199468-19680-14-git-send-email-john.johansen@canonical.com>
References: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>
	<1280199468-19680-14-git-send-email-john.johansen@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C506D2A.00AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 19:57:48 -0700 John Johansen wrote:

> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---
>  Documentation/kernel-parameters.txt |   12 ++++++++++--
>  MAINTAINERS                         |    8 ++++++++
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4ddb58d..b61f89f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -93,6 +93,7 @@ parameter is applicable:
>  			Documentation/scsi/.
>  	SECURITY Different security models are enabled.
>  	SELINUX SELinux support is enabled.
> +	APPARMOR AppArmor support is enabled.
>  	SERIAL	Serial support is enabled.
>  	SH	SuperH architecture is enabled.
>  	SMP	The kernel is an SMP kernel.
> @@ -254,8 +255,8 @@ and is between 256 and 4096 characters. It is defined in the file
>  			control method, with respect to putting devices into
>  			low power states, to be enforced (the ACPI 2.0 ordering
>  			of _PTS is used by default).
> -			s4_nonvs prevents the kernel from saving/restoring the
> -			ACPI NVS memory during hibernation.
> +			nonvs prevents the kernel from saving/restoring the
> +			ACPI NVS memory during suspend/hibernation and resume.
>  			sci_force_enable causes the kernel to set SCI_EN directly
>  			on resume from S1/S3 (which is against the ACPI spec,
>  			but some broken systems don't work without it).


Is that piece supposed to be part of this patch set?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
