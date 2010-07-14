Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0GNBgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:36:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57521 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0GNBgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sewHGq7Gf2GY9G8M4foVOwctnQeFSF+z9ZDkydoHHIu7UqS3qwJe2y5gKb3SQ69TKw
         6xvmfblehMtQZYL/j1Kp/gJKUUn6VySnMHkjKuKIXmMwo8+jwKnqNKX7ipg38N4AYxQj
         hlk9XoAmWIV8MitKU9kErqsR/WAIThZ9dCCRE=
MIME-Version: 1.0
In-Reply-To: <95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
References: <909896077.345011279054483129.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	<95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Date: Tue, 13 Jul 2010 18:36:41 -0700
X-Google-Sender-Auth: t7THioAn3U0XxEnetTgAX7jWe4U
Message-ID: <AANLkTin8lMv6Z1pcmjnswNjhdl7IRFVZy3XiAJbisOus@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
From: john stultz <johnstul@us.ibm.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 2:01 PM, Michal Schmidt <mschmidt@redhat.com> wrote:
> ----- "Borislav Petkov" <borislav.petkov@amd.com> wrote:
>> ... and this is strange, I didn't experience anything like that on
>> our X6 boxes here couple of months ago. But maybe something got changed
>> in later kernels to trigger that behavior. Michal, what chipset is that
>> and do you have the latest BIOS on it?
>
> The chipset is 890FX. Motherboard Asus M4A89TD PRO/USB3.
> BIOS is the latest version: 0901 (05/17/2010 according to dmidecode)
>
> I found another person reporting the same symptoms on
> GIGABYTE GA-MA770T-UD3P AthlonXII 620 (4 cores) kernel 2.6.33.5 (Mandriva)
> (http://www.abclinuxu.cz/poradna/hardware/show/308799, in Czech)

This also sounds like: https://bugzilla.kernel.org/show_bug.cgi?id=15289

thanks
-john
