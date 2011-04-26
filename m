Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1DZUQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:16:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:41694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1DZUQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:16:18 -0400
Message-ID: <4DB72810.60601@suse.cz>
Date: Tue, 26 Apr 2011 22:16:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: pefoley2@verizon.net, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: allow headerdep to work in KBUILD_OUTPUT and
 add targets to PHONY
References: <4DB4832E.6080009@verizon.net> <BANLkTikbo2tqcvAZ5_druZR+fYhBozakew@mail.gmail.com>
In-Reply-To: <BANLkTikbo2tqcvAZ5_druZR+fYhBozakew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.4.2011 08:52, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Apr 24, 2011 at 4:08 PM, Peter Foley <pefoley2@verizon.net> wrote:
>> This patch fixes the headerdep target so it will work when make is executed from KBUILD_OUTPUT.
>> It also adds a few targets to PHONY so they are always executed.
>>
> one change, one patch, please.
> 
> Why do you want that much consistency check to be always ran ?
> Especially `coccicheck', which rely on a non-common program being
> available.

The change is valid, but the changelog text is misleading. 'PHONY +=
foo' means that 'make foo' will always execute the commands for foo,
even if there is a file of the same name.

Michal
