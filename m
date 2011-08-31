Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1HaOgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:36:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab1HaOgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:36:47 -0400
Message-ID: <4E5E46FE.7050701@suse.cz>
Date: Wed, 31 Aug 2011 16:36:46 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Peter Foley <pefoley2@verizon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v2] kbuild: prevent make from deleting _shipped files
References: <alpine.LNX.2.00.1107311134490.30666@linux> <CACqU3MX7f2oNpDf6W124tfROfKq4PFsyvxiq=VtPJfv-gqUrww@mail.gmail.com> <CACqU3MU9BBsXjevz617v7YOBm+9RR1Wm49gi0jvs95yneQ2Yrg@mail.gmail.com> <alpine.LNX.2.00.1107311300190.16802@linux> <CACqU3MX=MVd8v2wKaFsNuXB2WsWq2jLsGfAdDEW9atoWbWE7Mg@mail.gmail.com> <alpine.LNX.2.00.1107311333320.53256@linux> <CACqU3MWHRJXRu5sOvyGhyiqV94=UmDfCxixf-okkGuphxUFRTQ@mail.gmail.com> <alpine.LNX.2.00.1107311437460.28279@linux> <CACqU3MVSH9HKdKFpw1dxKRHV1grPEMjnNbrAbE73yLrZbgYHcg@mail.gmail.com>
In-Reply-To: <CACqU3MVSH9HKdKFpw1dxKRHV1grPEMjnNbrAbE73yLrZbgYHcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.7.2011 21:03, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Jul 31, 2011 at 2:45 PM, Peter Foley <pefoley2@verizon.net> wrote:
>> commit 7373f4f (kbuild: add implicit rules for parser generation)
>> created a implicit rule chain (%.c: %.c_shipped: %.y).
>> Make considers the _shipped files to be intermediate files which
>> causes them to be deleted if they didn't exist before make was run.
>> Mark the _shipped files PRECIOUS to prevent make from deleting them.
>>
>> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> 
> Acked-by: Arnaud Lacombe <lacombar@gmail.com>

Applied to kbuild-2.6.git#kbuild.

Thanks,
Michal
