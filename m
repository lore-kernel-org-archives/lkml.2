Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1JIGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:25:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1JIGZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <1318136188.1844.56.camel@Joe-Laptop>
References: <1317650037-4648-1-git-send-email-linkinjeon@gmail.com>
	<20111005220813.GK23467@quack.suse.cz>
	<1317853198.3095.19.camel@Joe-Laptop>
	<20111006214159.GK31367@quack.suse.cz>
	<CAKYAXd8M6mnf0f_5RHpkjZ51suGnnFTHU1ZuJgvt5Nr0JVR1RQ@mail.gmail.com>
	<1318130976.1844.48.camel@Joe-Laptop>
	<CAKYAXd-s7-yRpD_UrrZPiXnRpTYEHG3O6w46_Cpn=sd6D9wN8g@mail.gmail.com>
	<1318136188.1844.56.camel@Joe-Laptop>
Date: Sun, 9 Oct 2011 15:25:54 +0900
Message-ID: <CAKYAXd80RzPbGPefmgZTdcv9cNBjgkCj13fuOMNgX6=WEiHkDA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] udf : enable error print in udf_read_tagged().
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/9 Joe Perches <joe@perches.com>:
> On Sun, 2011-10-09 at 13:44 +0900, NamJae Jeon wrote:
>> 2011/10/9 Joe Perches <joe@perches.com>:
>> > Not a good patch I think.
>> > You've broken format strings when they should be coalesced
>> > and the alignment looks odd.
>> Would you explain more ? I didn't understand your meaning yet.
>
> Format strings are allowed to exceed 80 columns.
> Arguments should be aligned to the open parenthesis
>
> For example:
>        pr_err("some really long format string longer than "
>                "80 columns and not broken into pieces, Count: %d\n",
>                count);
> is better as:
>        pr_err("some really long format string longer than 80 columns and not broken into pieces, Count: %d\n",
>               count);
>
> Coalesced format strings makes dmesg output easier to grep.
> count is not indented by 2 tabs, but 1 tab and 7 spaces.
>
> There's no hard and fast rule on the indentation.
>
> The patch I sent coalesced all format strings and
> used that alignment style.
Clear~ I will do it as your guide.
Thanks very much. joe~
>
>
