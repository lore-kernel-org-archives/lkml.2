Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab0LMRBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:01:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48555 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab0LMRBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SzJeUAWdahoThMmkRoCNFbSjBVCP3twvAouMBAf05e46x3mR7I4dVwv4v6E17BlFtG
         9OkUh2YzDJjLDQPYZUo2+irJvMcSWtt9usRv6MCPzwkAR5FI9iiUtSNzmPmVIcx3x+rH
         8fQmaRx4T7DWMqs0pSqIMiVpT03extfybrM8I=
MIME-Version: 1.0
In-Reply-To: <4e0d4bb9da2d1b0e1196ae2af4c2ddb8.squirrel@www.firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
	<20101212234751.76302B27BF@basil.firstfloor.org>
	<E87738D94A6AD54789B5B8D1BAEB06CC700C2347FF@azsmsx503.amr.corp.intel.com>
	<4e0d4bb9da2d1b0e1196ae2af4c2ddb8.squirrel@www.firstfloor.org>
Date: Mon, 13 Dec 2010 12:01:38 -0500
X-Google-Sender-Auth: 39NQhaBRDzps1nhtYBGWgPLgtN4
Message-ID: <AANLkTinPS1ejn-r7Vw-6u=g46Ngh12XkKKNQHBjg3LYQ@mail.gmail.com>
Subject: Re: [PATCH] [167/223] ACPI: debugfs custom_method open to non-root
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Brown, Len" <len.brown@intel.com>, "davej@redhat.com" <davej@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 3:57 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> 2.6.35-longterm review patch.  If anyone has any objections, please let
>>> me know.
>>
>> is -longterm something that happens after -stable runs out of gas?
>
> Yes (but not for all kernels)
>
>> Note that this particular patch applies back to 2.6.33.
>
> Paul G. could consider it for his 2.6.34 then.

Yes, thanks.  If people creating/nominating patches happen to have that
kind of knowledge handy (i.e. for what version(s) it makes sense) then I'd
encourage everyone to try capturing that somewhere - it will be handy for
all the longterm maintainers.

Paul.

> -Andi
