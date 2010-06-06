Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0FFG1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 02:27:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39314 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab0FFG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 02:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RmQCsHDTu5645ITHCk98mEt4snf4zaNt5qoZxozpDFGDYbPLgQcPTGMMD0OQjKG6xg
         tw/7RTrK8xw9+go9UA9IV0AtA5clNkYh2cl5n3phEh7eACjr5Of4TayB4Ui5QdHhg9J5
         ayibiukY8xgpYRwDmXtaOLEA4VmprAlxbaOWo=
Message-ID: <4C0B3FDF.6080303@gmail.com>
Date: Sun, 06 Jun 2010 08:27:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100527 SUSE/3.1rc1-3.3 Thunderbird/3.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       linux-video@atrey.karlin.mff.cuni.cz
Subject: Re: BUG kmalloc-4096: Poison overwritten
References: <4C0B3C5B.5040703@gmail.com>
In-Reply-To: <4C0B3C5B.5040703@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 08:12 AM, Justin P. Mattock wrote:
> =============================================================================
> 
> [    0.002046] BUG kmalloc-4096: Poison overwritten
> [    0.002051]
> -----------------------------------------------------------------------------
> 
> [    0.002052]
> [    0.002063] INFO: 0xffff88003ec09e00-0xffff88003ec09e9f. First byte
> 0x20 instead of 0x6b
> [    0.002073] INFO: Slab 0xffffea0000dba1c0 objects=7 used=1
> fp=0xffff88003ec09048 flags=0x40000000000040c3
> [    0.002082] INFO: Object 0xffff88003ec09048 @offset=4168
> fp=0xffff88003ec0a090
> [    0.002083]
> [    0.002093] Bytes b4 0xffff88003ec09038:  00 00 00 00 00 00 00 00 5a
> 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> [    0.002114]   Object 0xffff88003ec09048:  6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
...
> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [    0.002999]   Object 0xffff88003ec09df8:  6b 6b 6b 6b 6b 6b 6b 6b 20
> 07 20 07 20 07 20 07 kkkkkkkk........
> [    0.002999]   Object 0xffff88003ec09e08:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e18:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e28:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e38:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e48:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e58:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e68:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e78:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e88:  20 07 20 07 20 07 20 07 20
> 07 20 07 20 07 20 07 ................
> [    0.002999]   Object 0xffff88003ec09e98:  20 07 20 07 20 07 20 07 6b
> 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk
> [    0.002999]   Object 0xffff88003ec09ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b

Just guessing, grey spaces which should go to video ram?

-- 
js
