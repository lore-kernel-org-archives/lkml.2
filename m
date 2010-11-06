Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0KFPCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:02:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51967 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0KFPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SFoLU3PBKe9DzpAInghk1uE79nkam/a/0NfYJsO/R8XJ9d5/30GZj2Yf3cOOq88Mgb
         lyBtiNdEh8YIfzr4JSlBCZ1Co1ww6wmaqg7a/R/lj7CkcEEZ1ATZCodlxsUl75N5/toy
         3+k28OXzghsj+81xrh5jeC9ZXPwH7X/Ds4SaY=
Message-ID: <4CD56D56.20005@gmail.com>
Date: Sat, 06 Nov 2010 15:59:34 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/16 v2] pramfs: super block operations
References: <4CD51847.20306@gmail.com> <20101106131257.GB13522@gandalf.local>
In-Reply-To: <20101106131257.GB13522@gandalf.local>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/11/2010 14:12, James Hogan ha scritto:
> Hi,
> 
> On Sat, Nov 06, 2010 at 09:56:39AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Super block operations.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>> diff -Nurp linux-2.6.36-orig/fs/pramfs/super.c linux-2.6.36/fs/pramfs/super.c
>> --- linux-2.6.36-orig/fs/pramfs/super.c	1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.36/fs/pramfs/super.c	2010-09-25 14:09:47.000000000 +0200
> <snip>
>> +	pram_dbg("max name length %d\n", PRAM_NAME_LEN);
> 
> I get a warning on this line that could be avoided:
> 
> fs/pramfs/super.c: In function ‘pram_init’:
> fs/pramfs/super.c:308: warning: format ‘%d’ expects type ‘int’, but
> argument 2 has type ‘long unsigned int’
> 
> Cheers
> James
> 


Mmmm, very strange, I don't have that warning, maybe the compiler
version. I'll fix it with an int cast to avoid it.

Marco
