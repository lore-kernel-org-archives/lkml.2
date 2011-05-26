Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1EZBaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:30:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58663 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1EZBaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jXDfSf6KJYhSfviK2s3O2dosa/k8kmqRKlivWLT2UgtsOAjWpuK9gS3j/OQrfVzQCo
         YnjD4Uuemv6EXpjAeU8y4ohkphvY7TxJjxirVy+r0mVurMtU9wW2O/rV79zF5/ZxHdxO
         Vs1dJvLekLWYlMj8YjtTfsEIClf4Gdc7YmY1A=
MIME-Version: 1.0
In-Reply-To: <20110506153344.GA16977@sgi.com>
References: <20110506153344.GA16977@sgi.com>
Date: Wed, 25 May 2011 18:30:13 -0700
X-Google-Sender-Auth: _qkuAkp_RhFiVuEAeAh-MCwAvbo
Message-ID: <BANLkTim=4+ppfJH45PL4vGALpQELWpQk8w@mail.gmail.com>
Subject: Re: [PATCH] x86: poll waiting for I/OAT DMA channel status
From: Dan Williams <dan.j.williams@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 8:33 AM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> For certain system configurations a 5 usec udelay before checking I/OAT DMA
> channel status is sometimes not sufficient, resulting in a false failure
> status and unnecessary freeing of channel resources.  Conversely, for many
> configurations 5 usec is longer than necessary.
>
> Loop for up to 20 usec waiting for successful status before failing.
>
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ___

Applied, but for future reference fix your scripts to use "---"
instead of "___" for the separator after the Signed-off-by otherwise
the diffstat information gets included in the changelog when apply the
patch with "git am".

--
Dan
