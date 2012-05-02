Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab2EBBX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:23:29 -0400
Received: from li235-22.members.linode.com ([173.255.225.22]:49792 "EHLO
	erley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab2EBBX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:23:27 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2012 21:23:26 EDT
Message-ID: <4FA089F9.1020602@erley.org>
Date: Tue, 01 May 2012 21:12:25 -0400
From: Pat Erley <pat-lkml@erley.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120415 Thunderbird/12.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lautriv <admin@coldplug.net>,
        Jim Cromie <jim.cromie@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
References: <20120427094637.GV3157@wantstofly.org> <CA+icZUXNZ=exTnR=OgD_9bpt_0s-KnR+v-K6u+XzQr4HBoTQHQ@mail.gmail.com> <20120427095842.GW3157@wantstofly.org> <CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com> <20120427101732.GX3157@wantstofly.org> <CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com> <CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com> <20120427185809.GZ3157@wantstofly.org> <CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com> <CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com> <20120501125102.GN3157@wantstofly.org> <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
In-Reply-To: <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 09:54 AM, Sedat Dilek wrote:
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -5225,6 +5225,7 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
>   }
>
>   enum {
> +	MWL8361P = 0,
>   	MWL8363 = 0,
>   	MWL8687,
>   	MWL8366,

I'm not an expert, but isn't this giving both 8361P and 8363 the same values in the enum?

Is that intended?

Pat Erley
