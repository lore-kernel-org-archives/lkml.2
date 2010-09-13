Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0IMQIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:08:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54856 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0IMQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:08:12 -0400
Message-ID: <4C8E4C0D.6010502@zytor.com>
Date: Mon, 13 Sep 2010 09:06:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>, Valdis.Kletnieks@vt.edu,
        =?UTF-8?B?U2jDqXJhYg==?= <Sebastien.Hinderer@ens-lyon.org>,
        Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema> <4C76D9A0.2010907@zytor.com> <20100829205929.GA3309@pema> <20100913100719.GA3903@pema> <54870.1284390647@localhost> <20100913152249.GC5364@const.bordeaux.inria.fr>
In-Reply-To: <20100913152249.GC5364@const.bordeaux.inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 08:22 AM, Samuel Thibault wrote:
> 
> Again, I'm not sure we really should try hard to make it automatically
> detected (and thus always enabled).  Having to pass a kernel parameter
> to enable the functionality is completely fine, since installing Linux
> on this device requires quite some tinkering already.
> 

Could you describe this kind of tinkering?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

