Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1DSIDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:03:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:58794 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab1DSID1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:03:27 -0400
Message-ID: <4DAD41CE.5060702@suse.cz>
Date: Tue, 19 Apr 2011 10:03:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: LOCALVERSION in setlocalversion
References: <BANLkTikYuYVvXiHvi_kr2H7n29k=veThtw@mail.gmail.com>	<4DAD327B.4030904@suse.cz> <BANLkTikspr9jVNF-VZbnc_MxUYNWad7Kkg@mail.gmail.com>
In-Reply-To: <BANLkTikspr9jVNF-VZbnc_MxUYNWad7Kkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.4.2011 09:35, Haojian Zhuang wrote:
> I still have a question. I can't find the semantic of
> ${LOCALVERSION+set} in some
> shell tutorials. Could you help me to figure out a link of introducing this?

It's a test if LOCALVERSION is set or not. See for instance
http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_06_02,
scroll down to the table that explains the various expansions.

Michal
