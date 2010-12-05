Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0LEUF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:05:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65326 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab0LEUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lMbGkd6dBm8U1E0VfRmeRTk+Aked4XXj1e8HQP9DvCgCUgAtHOs09VuYgMNSISA6uG
         u57jIheYO94Arb756x9VQU834E1YI5dc5Ne1LqFog5n/HIttyBsnmmFLumS8Idrx65UG
         LnqMcegZDwhHgeY+1l+AyBzuK9Przo+NHnxoM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjWEDWaz75-DSemfyNBUU7VLVhd7qzPpD-Lk5N@mail.gmail.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
	<AANLkTimjWEDWaz75-DSemfyNBUU7VLVhd7qzPpD-Lk5N@mail.gmail.com>
Date: Sun, 5 Dec 2010 12:05:54 -0800
Message-ID: <AANLkTikYy2iVbVkR5koagNiuD2GdoPhPniWshRAHoCKQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] dmaengine/dw_dmac: enhancements to allow use on other platforms
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Fri, Dec 3, 2010 at 3:34 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Looks like this whole series needs to go through the dmaengine tree
> but you missed cc'ing me on patch 4/4, found it now.
>
> I'd like an acked-by from Haavard, but otherwise looks good.

Looks good to me, but since I'm no longer working for Atmel, I think
it's best if you ask Hans-Christian.

But since you asked:

Acked-by: Haavard Skinnemoen <hskinnemoen@gmail.com>
