Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1IFPNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:13:10 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:34216 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1IFPNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:13:09 -0400
Message-ID: <4E663882.4050404@parrot.com>
Date: Tue, 6 Sep 2011 17:13:06 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: randconfig broken on choice
References: <4E65DF36.6040507@parrot.com> <CACqU3MU9nuW+a3AJfY_PRqFH_tgaKtBJrp1pU2xpB_dHYANBXg@mail.gmail.com>
In-Reply-To: <CACqU3MU9nuW+a3AJfY_PRqFH_tgaKtBJrp1pU2xpB_dHYANBXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnaud Lacombe a écrit :
> Hi,
> 
> On Tue, Sep 6, 2011 at 4:52 AM, Matthieu CASTET
> <matthieu.castet@parrot.com> wrote:
>> Hi,
>>
>> I am using v3.1-rc4 and make randconfig look broken for choice.
>> The choice config is always the same or choice entry can have more than one entry.
>>
> Could you includes testcases showing that behavior, please ?
$ make randconfig

$ grep -e SLUB -e SLAB -e SLOB .config
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLOB=y
# CONFIG_FAILSLAB is not set

We have 2 choice selected (SLUB and SLOB). You may run randconfig (more than one
time to get this result).

Matthieu
