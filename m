Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1AFMr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:47:27 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:59713 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1AFMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:47:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dXY5AHAifyeeuKXrdyUYpgJkJXbnXvZDTE+ceeTHQNCfVrPBOl2Dd07FbNj1NAZfsU
         E/FaMkJVLY0OhM706Ptb10/ocEZPZ1ZACZxrUcHnK12IdPyu1X8zDNjuVHAeCIAfwAMr
         6btmL3lx2XRmQSminpvikpcIX+rIIHNgH4Xps=
Message-ID: <4D25B9D6.80503@gmail.com>
Date: Thu, 06 Jan 2011 13:47:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@suse.de>
Subject: Re: [34-longterm 000/260] v2.6.34.8 longterm review
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com> <4D21A7E8.3090709@gmail.com> <20110104191158.GO30150@windriver.com>
In-Reply-To: <20110104191158.GO30150@windriver.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing:
gregkh (32-stable)
ak (35-stable)

On 01/04/2011 08:11 PM, Paul Gortmaker wrote:
> If you want to look around at what else is in "next_round" you can grab
> the queue from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.34.git
> 
> Let me know if you still think something is missing, and/or call out the
> upstream commit IDs explicitly and I'll do the right thing.

Hi,
e2efafbf139d2bfdfe96f2901f03189fecd172e4
is still missing (I've just checked SLE11SP1 and openSUSE 11.3, which is
based on .32 and .34 respectively and the problem is easily reproducible
there). It is trivial to be backported.

thanks,
-- 
js
