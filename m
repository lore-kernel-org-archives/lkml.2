Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1DZO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:27:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49329 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1DZO1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W91YMOeD2ZfAfeabZgHatyvksArTpduGQKcH/36HYfMPEsGpvh53Rw7NSfjyjYjdgT
         oUMKC/pEkguWJIPaQB/TsQZ5bdAZyzreCkJ5pg8jkN0D/fnYSif3nLqNkm5/EwuHJ/sF
         S9L+9u8btoErwVXvLI45pSmplORLiV/lVBP18=
MIME-Version: 1.0
In-Reply-To: <4DB6D3DE.5040302@verizon.net>
References: <4DB608EE.1060502@verizon.net>
	<BANLkTi=sjE-YF1+q1++Bk78n4bvs6W5Wgg@mail.gmail.com>
	<4DB6D3DE.5040302@verizon.net>
Date: Tue, 26 Apr 2011 22:27:49 +0800
Message-ID: <BANLkTikXHSXxq3rP5vKcXv+52MbfHDjLoQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: fix sed error in export_report.pl
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: pefoley2@verizon.net
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, mmarek@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:17 PM, Peter Foley <pefoley2@verizon.net> wrote:
> On 4/26/2011 2:40 AM, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Mon, Apr 25, 2011 at 7:51 PM, Peter Foley <pefoley2@verizon.net> wrote:
>>> This patch fixes a sed error in export_report.pl by escaping a $.
>>>
>> Which error ?
>>
>> Thanks,
>>  - Arnaud
>>
>
> This is the error I get:
>
> make -C /usr/src/git O=/root/linux/t/. export_report
> perl /usr/src/git/scripts/export_report.pl
> sed: -e expression #1, char 5: unterminated `s' command
> sh: line 1: .mod.c/: No such file or directory

Please include this in your changelog.

But anyway,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
