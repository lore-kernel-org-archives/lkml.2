Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1BHVpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:45:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53289 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1BHVpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U3hO0QGhrd3nG/eXTWOa0V8I5/gZvsSsBCCsB1M40750THaRMLjz8AHJst4LD/AD1r
         qRTfNFvm1crVcL5rckuluXLzvP+sGI3bom26KtG8YnpvHB3iq/t6+6AksGrAsZbTtbgl
         tWX8vPhsCU/6RDNJQ79VRfq3gb2TG3VLZf2RQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=BXgDKk3c97XJ+WiCiiPjiYL3dZPWiGg=i3KXp@mail.gmail.com>
References: <1294774649.1337.7.camel@d941e-10>
	<AANLkTi=BXgDKk3c97XJ+WiCiiPjiYL3dZPWiGg=i3KXp@mail.gmail.com>
Date: Tue, 8 Feb 2011 22:45:42 +0100
Message-ID: <AANLkTi=cfNXONM5EvGPaS7N2kgAbUZmn1Oe+qE9fd7aO@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: Use timeouts returned from TPM
From: Guillaume Chazarain <guichaz@gmail.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ + jmorris ]

On Thu, Jan 27, 2011 at 11:44 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> On Tue, Jan 11, 2011 at 8:37 PM, Stefan Berger
> <stefanb@linux.vnet.ibm.com> wrote:
>> The current TPM TIS driver in git discards the timeout values returned
>> from the TPM.
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c4ff4b829ef9e6353c0b133b7adb564a68054979
> broke the TPM for me on a thinkpad T410. When using the TPM, dmesg
> complains:
>
> [   65.728310] tpm_tis 00:0b: Operation Timed out
> [   67.651450] tpm_tis 00:0b: Operation Timed out
> [   69.669421] tpm_tis 00:0b: Operation Timed out
>
> This patch fixes it, so consider it:
>
> Tested-by: Guillaume Chazarain <guichaz@gmail.com>

This patch (https://lkml.org/lkml/2011/1/11/341) fixes a regression
introduced in 2.6.38-rc3, any chance of having it merged?

Thanks.

-- 
Guillaume
