Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2IYBQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:16:54 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:35575 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750861Ab2IYBQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:16:53 -0400
Message-ID: <50610602.5050003@xenotime.net>
Date: Mon, 24 Sep 2012 18:16:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Franklin Wei <frankhwei536@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: arch/x86/lib/inat.c Error
References: <CAEMuUziMGAM4UOeOGWwG9jiceU9K7NSzqbryMxHwFDfmOfqQdA@mail.gmail.com>	<20120924075957.GA5151@liondog.tnic> <CAEMuUzjbudxmGOZqB2HBLNa7p=aRqdiNKNXZLRV7c9yKPJ7TxQ@mail.gmail.com>
In-Reply-To: <CAEMuUzjbudxmGOZqB2HBLNa7p=aRqdiNKNXZLRV7c9yKPJ7TxQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 04:04 PM, Franklin Wei wrote:

> Here it is
> 
> On 9/24/12, Borislav Petkov <bp@alien8.de> wrote:
>> On Sun, Sep 23, 2012 at 04:34:24PM -0400, Franklin Wei wrote:
>>> Something wrong with lines 29-86
>>> Error message when compiling:
>>>   CC      arch/x86/lib/inat.o
>>> arch/x86/lib/inat.c: In function ‘inat_get_opcode_attribute’:
>>> arch/x86/lib/inat.c:29: error: ‘inat_primary_table’ undeclared (first
>>> use in this function)
>>> arch/x86/lib/inat.c:29: error: (Each undeclared identifier is reported
>>> only once
>>> arch/x86/lib/inat.c:29: error: for each function it appears in.)
>>> arch/x86/lib/inat.c: In function ‘inat_get_escape_attribute’:
>>> arch/x86/lib/inat.c:48: error: ‘inat_escape_tables’ undeclared (first
>>> use in this function)
>>> arch/x86/lib/inat.c: In function ‘inat_get_group_attribute’:
>>> arch/x86/lib/inat.c:67: error: ‘inat_group_tables’ undeclared (first
>>> use in this function)
>>> arch/x86/lib/inat.c: In function ‘inat_get_avx_attribute’:
>>> arch/x86/lib/inat.c:86: error: ‘inat_avx_tables’ undeclared (first use
>>> in this function)
>>> make[1]: *** [arch/x86/lib/inat.o] Error 1
>>> make: *** [arch/x86/lib] Error 2
>>
>> That's because all those _tables thingies are included from a
>> "inat-tables.c" in the same directory but it somehow doesn't get
>> included?!
>>
>> Can we get your .config pls? Also, you're doing a "normal" kernel build
>> on the command line, right?
>>
>> Thanks.


Your config builds OK for me.
Do you see this line in your build output before inat.c is built?


  GEN     arch/x86/lib/inat-tables.c


-- 
~Randy
