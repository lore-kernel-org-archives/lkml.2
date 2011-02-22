Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1BVRjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:39:43 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:56679 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1BVRjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=m4w2aQpw4qRriWha9oHQ9Fg9m2T1IkRAOqwpWwqGXIufiVsAlWwy+xvdVtDqKM6IfB
         fzxUyy6hSCL4nLk/U2EP5b83DUlUgW5CAC+rsbw9SoFswRR8EfdnlREzQxhRN56JxNAW
         EBZoEyRTLGeDZrXeIf6MfvLs8gduk1ga834Iw=
Message-ID: <4D63F4D9.6030505@gmail.com>
Date: Tue, 22 Feb 2011 18:39:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com> <4D629427.8020500@gmail.com> <4D629D03.90801@linux.vnet.ibm.com> <4D62CD93.3040206@gmail.com> <4D62D930.8060304@linux.vnet.ibm.com> <4D62DCBA.9050609@gmail.com> <4D62E221.7010104@linux.vnet.ibm.com> <4D62E2F2.4060406@gmail.com> <4D63066D.3080701@linux.vnet.ibm.com> <4D6376A9.5060704@gmail.com> <4D63A4B8.8040106@linux.vnet.ibm.com>
In-Reply-To: <4D63A4B8.8040106@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 12:57 PM, Stefan Berger wrote:
> The forthcoming patch will simply also adapt the other 2 values and
> multiply them by 1000. The reason for the suspend failure is the 2nd
> timeout with TPM_SaveState command being of medium duration.
> 
> There will be a 2nd patch for re-enabling the TPM's interrupts that the
> BIOS may (this may be BIOS-dependent) have disabled while sending a
> command (TPM_Startup) to the TPM upon resume and having used polling
> mode and leaving it with the interrupts disabled.
> 
> I'd appreciate it if you tested both of them.

I didn't get any. Could you add a pointer to them?

BTW. there is another guy who hit this. He has:
/sys/devices/pnp0/00:02/timeouts:1000000 2000 150000

like I do.

regards,
-- 
js
