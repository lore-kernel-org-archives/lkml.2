Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab1EBPbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:31:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab1EBPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:31:10 -0400
Message-ID: <4DBECE3C.5070008@suse.cz>
Date: Mon, 02 May 2011 17:31:08 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
References: <20110502121817.645d544e.sfr@canb.auug.org.au> <20110502022417.GA11804@redhat.com> <20110502134524.40da4245.sfr@canb.auug.org.au> <20110502142454.a7091ad5.sfr@canb.auug.org.au> <20110502145338.7be2fdbc.sfr@canb.auug.org.au>            <20110502111337.GA15769@sepie.suse.cz> <10763.1304349435@localhost>
In-Reply-To: <10763.1304349435@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.5.2011 17:17, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 02 May 2011 13:13:37 +0200, Michal Marek said:
>
>> +# We test for support of the -Wunused-but-set-variable option, because
>> +# some version of gcc will happily accept any -Wno-* switch and complain
>> +# later during build.
>> +ifeq ($(call cc-option-yn, -Wunused-but-set-variable), y)
>> +KBUILD_CFLAGS += -Wno-unused-but-set-variable
>> +endif
>
> Do we need to do this more generically for all the other -Wno-foo
> options under the various W={123} options?

I only see -Wno-unused-parameter in scripts/Makefile.build and that 
should be supported by any gcc version. Also please have a look at 
http://marc.info/?l=linux-kernel&m=130433840412201&w=2, which is an 
updated version.

Michal
