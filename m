Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2A2Kwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 05:52:50 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:42371 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2A2Kwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 05:52:49 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jan 2012 05:52:48 EST
Message-ID: <4F252441.3090507@calvaedi.com>
Date: Sun, 29 Jan 2012 11:49:37 +0100
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: Jonathan Nieder <jrnieder@gmail.com>, John Hughes <john@atlantech.com>,
        Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [Sony Vaio TX3] TPM chip prevents machine from suspending a second
 time
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20120121170157.GA18053@burratino> <4F1DC8A3.60901@linux.vnet.ibm.com>
In-Reply-To: <4F1DC8A3.60901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/12 21:52, Stefan Berger wrote:
>
> Can you apply the patch below to your tpm_tis.c (or somewhere else in 
> the kernel) and let me/us know what it reports in 'dmesg' upon a 
> 'modprobe tpm_tis'?

[   48.826151] tpm_tis 00:07: dmi: 0: (null)
[   48.826157] tpm_tis 00:07: dmi: 1: Phoenix Technologies LTD
[   48.826161] tpm_tis 00:07: dmi: 2: R0021N3
[   48.826165] tpm_tis 00:07: dmi: 3: 05/09/2006
[   48.826169] tpm_tis 00:07: dmi: 4: Sony Corporation
[   48.826173] tpm_tis 00:07: dmi: 5: VGN-TX3XP_B
[   48.826177] tpm_tis 00:07: dmi: 6: J001QHZL
[   48.826181] tpm_tis 00:07: dmi: 7: 28244651-5000176
[   48.826186] tpm_tis 00:07: dmi: 8: DC744BA0-5B3C-11D9-8822-0013A93CCD4D
[   48.826190] tpm_tis 00:07: dmi: 9: Sony Corporation
[   48.826195] tpm_tis 00:07: dmi: 10: VAIO
[   48.826199] tpm_tis 00:07: dmi: 11: N/A
[   48.826204] tpm_tis 00:07: dmi: 12: N/A
[   48.826208] tpm_tis 00:07: dmi: 13: N/A
[   48.826213] tpm_tis 00:07: dmi: 14: Sony Corporation
[   48.826217] tpm_tis 00:07: dmi: 15: 10
[   48.826221] tpm_tis 00:07: dmi: 16: N/A
[   48.826225] tpm_tis 00:07: dmi: 17: J001QHZL
[   48.826229] tpm_tis 00:07: dmi: 18:
[   48.826235] tpm_tis 00:07: 1.2 TPM (device-id 0xB, rev-id 16)


