Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab1JIEor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 00:44:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39726 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1JIEoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 00:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <1318130976.1844.48.camel@Joe-Laptop>
References: <1317650037-4648-1-git-send-email-linkinjeon@gmail.com>
	<20111005220813.GK23467@quack.suse.cz>
	<1317853198.3095.19.camel@Joe-Laptop>
	<20111006214159.GK31367@quack.suse.cz>
	<CAKYAXd8M6mnf0f_5RHpkjZ51suGnnFTHU1ZuJgvt5Nr0JVR1RQ@mail.gmail.com>
	<1318130976.1844.48.camel@Joe-Laptop>
Date: Sun, 9 Oct 2011 13:44:44 +0900
Message-ID: <CAKYAXd-s7-yRpD_UrrZPiXnRpTYEHG3O6w46_Cpn=sd6D9wN8g@mail.gmail.com>
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
> On Sun, 2011-10-09 at 12:16 +0900, NamJae Jeon wrote:
>> 2011/10/7 Jan Kara <jack@suse.cz>:
>> > On Wed 05-10-11 15:19:58, Joe Perches wrote:
>> >> On Thu, 2011-10-06 at 00:08 +0200, Jan Kara wrote:
>> >> > Hello,
>> >> >
>> >> > On Mon 03-10-11 22:53:57, Namjae Jeon wrote:
>> >> > > While reading metadata, if a problem occurs, Print out only one of the
>> >> > > five case.(It also does not show a checksum properly.) Because currently
>> >> > > it have been disable by undef udf_debug.  If there is a problem with
>> >> > > scratched disc or loader, the user needs to know which error happened.
>> >> > > And I use pr_fmt instead of printk by joe's suggestion. I try to modify
>> >> > > totally it to pr_fmt also.
>> >>
>> >> >   Thanks for the patch. I'm willing to take the patch since it's an
>> >> > improvement but what would be even nicer is to have error reporting like in
>> >> > ext3 / ext4. We would have functions udf_info, udf_warn, udf_err which
>> >> > also print sb->s_id with each error so that user can better identify on
>> >> > which filesystem error happened.
>> >>
>> >> Modifying the follow-on patch I sent would be pretty trivial.
>> >  Sure, I can do that but if Namjae is willing to do it, I'd have less work
>> > :).
>> Hi. Jan.
>>
>> Currently I can not send a patch using git send-email.
>> maybe it is the problem related with git or patch size...
>> So I attach a patch. Is it okay? or I resend a patch again..
>> plz review attach patch.
>> Thanks.
>
Hi. Joe.
> Not a good patch I think.
>
> You've broken format strings when they should be coalesced
> and the alignment looks odd.
Would you explain more ? I didn't understand your meaning yet.

>
> udf_debug should also add
>        struct super_block *sb, const char *function,
> as the leading arguments.
okay. I will~
Thanks for your review.
>
>
