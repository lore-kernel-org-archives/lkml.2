Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1CVM6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:58:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50726 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab1CVM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UZTstjy2QjLCW1qEtdGCGsqmLYug7GCtK14sIcIlA9PLkL8SOV8B1+LB/QbRIq2HG3
         v/Ny3VQPCApYJ8ZcBOvcBiHr5Cu+rkB20Sff7kh8Ig7J25g3YX4Jy9YRJIdlf0Q46WCc
         LzmGxs0tSdA6E4QxlLRhntGGWEXjSutRNwCvQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimS1ss=977x3d-7Wcpj0wGthzW3_G+wqF1wQMc3@mail.gmail.com>
References: <4D81708D.5090607@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1103220956350.14837@tundra.namei.org>
	<AANLkTimS1ss=977x3d-7Wcpj0wGthzW3_G+wqF1wQMc3@mail.gmail.com>
Date: Tue, 22 Mar 2011 13:58:18 +0100
Message-ID: <AANLkTi=uZME7Pr761VJkEiJYFp7L3iexjV3JeMmL63it@mail.gmail.com>
Subject: Re: [GIT PULL] TPM driver robustness fixes
From: Peter Huewe <huewe.external.infineon@googlemail.com>
To: James Morris <jmorris@namei.org>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,


> These patches don't have proper subjects.

The patch subjects were somehow mangled as it seems.
The original patch subjects were
- char/tpm: Fix uninitialized usage of data buffer
- char/tpm: Call tpm_transmit with correct size
- char/tpm: Zero buffer after copying to userspace

I've sent them to the kernel security list but as it seems during the
transmission to tpmdd the subjects were stripped.
If desired I can resend them.


> Consider what happens in memset if copy_to_user fails.
Sorry I don't see it. Can you please clearify the problem for me?



> One of the patches is flagged with "Discussion needed ...", without any
> evidence of that the discussion happened.
You're right about that - no discussion happened ;)


Peter
(p.s.: again in plaintext - sorry)
