Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab1FFTeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:34:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45839 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab1FFTeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m9+AgsY2kytDhz351llxkJSTG+gUyhHgpb3S5CQJ1mAKf3fxb3uRgd7o+0a1SBvoFH
         ibCRHcpKUb66yOr0rUb2rjdPn57w4tdtcLD0KKjNRtC2Sql5mYsjZ/NHo5ekaVCw9z0J
         /vyUD5u8VXx2aByBrcaYkO/zHUsBrrNx1HdbY=
MIME-Version: 1.0
In-Reply-To: <4DED25AD.9050504@uw.no>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
	<1307386711-8866-2-git-send-email-lacombar@gmail.com>
	<4DED25AD.9050504@uw.no>
Date: Mon, 6 Jun 2011 15:34:00 -0400
Message-ID: <BANLkTi=DmPSGzevPDcepmHYQrcAhVOOEkA@mail.gmail.com>
Subject: Re: [PATCH 1/9] kconfig: annotate non-trivial fall-trough
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Daniel K." <dk@uw.no>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 6, 2011 at 3:08 PM, Daniel K. <dk@uw.no> wrote:
> Arnaud Lacombe wrote:
>>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  scripts/kconfig/conf.c     |    4 ++++
>>  scripts/kconfig/confdata.c |    5 +++++
>>  scripts/kconfig/gconf.c    |    1 +
>>  scripts/kconfig/mconf.c    |    1 +
>>  4 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
>> index 006ad81..8be7374 100644
>> --- a/scripts/kconfig/conf.c
>> +++ b/scripts/kconfig/conf.c
>> @@ -106,6 +106,7 @@ static int conf_askvalue(struct symbol *sym, const
>> char *def)
>>                        return 0;
>>                }
>>                check_stdin();
>> +               /* FALLTHOUGH */
>>        case oldaskconfig:
>>                fflush(stdout);
>>                xfgets(line, 128, stdin);
>
> Could it be done using the inside voice?
>
> s/FALLTHOUGH/fall through/
>
Sure, I followed the LINT syntax and missed
`Documentation/CodingStyle' defined its own. [And I actually managed
to make a typo in a so trivial patch :(]. Anyway, thanks for pointing
that out. The tree at github contains the fixed version.

 - Arnaud
