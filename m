Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0IMPtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:49:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab0IMPtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:49:39 -0400
Message-ID: <4C8E47D9.6050005@zytor.com>
Date: Mon, 13 Sep 2010 08:48:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: =?UTF-8?B?U2jDqXJhYg==?= <Sebastien.Hinderer@ens-lyon.org>
CC: Valdis.Kletnieks@vt.edu, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema> <4C76D9A0.2010907@zytor.com> <20100829205929.GA3309@pema> <20100913100719.GA3903@pema> <54870.1284390647@localhost> <20100913152511.GA3916@pema>
In-Reply-To: <20100913152511.GA3916@pema>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 08:25 AM, Shérab wrote:
> 
>> (For that matter, are there machines that will get indigestion
>> at this sort of unexpected inb() access?)
> 

Yes, there are... since it's an address which can contain any kind of
I/O device.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

