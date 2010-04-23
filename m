Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0DWQK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:10:58 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:38456 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0DWQKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e2RiBAV/4va6lezSzvJ5AqugXmLPHWGt6YDA0PYr5d4TY3bRZxAcJmGgX2VTfh3NHB
         lI04qr3Qr++sqxUHe9tY331yESZc4gXn1p7t4HaAK98J9naoTL2b+FsBxM911wzgUOoT
         Ci0MWSk2Zp6LsiR0BWbh6miFvslARSHlZVh6U=
MIME-Version: 1.0
In-Reply-To: <20100423085021.b54f98c5.randy.dunlap@oracle.com>
References: <1271983035-26401-1-git-send-email-chihau@gmail.com>
	 <20100423085021.b54f98c5.randy.dunlap@oracle.com>
Date: Fri, 23 Apr 2010 12:10:51 -0400
Message-ID: <s2jf5ca57691004230910nfac5a247ta691c07b71b4d7e1@mail.gmail.com>
Subject: Re: [PATCH] Security: inode: Fix code style issues
From: Chihau Chau <chihau@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: jmorris@namei.org, eparis@redhat.com, viro@zeniv.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

2010/4/23 Randy Dunlap <randy.dunlap@oracle.com>:
> On Thu, 22 Apr 2010 20:37:15 -0400 Chihau Chau wrote:
>
>> From: Chihau Chau <chihau@gmail.com>
>>
>> This fixes two code style issues:
>>
>> - A space required after that close brace '}'
>
> Why?  do we say that somewhere?
>

I was used the checkpatch.pl script written by Dave Jones, Joel Schopp
and Andy Whitcroft.

>
>>
>> - A space required after that ','
>>
>> Signed-off-by: Chihau Chau <chihau@gmail.com>
>> ---
>>  security/inode.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/inode.c b/security/inode.c
>> index c3a7938..f875f47 100644
>> --- a/security/inode.c
>> +++ b/security/inode.c
>> @@ -124,7 +124,7 @@ static inline int positive(struct dentry *dentry)
>>
>>  static int fill_super(struct super_block *sb, void *data, int silent)
>>  {
>> -     static struct tree_descr files[] = {{""}};
>> +     static struct tree_descr files[] = { {""} };
>>
>>       return simple_fill_super(sb, SECURITYFS_MAGIC, files);
>>  }
>> @@ -208,7 +208,7 @@ struct dentry *securityfs_create_file(const char *name, mode_t mode,
>>       struct dentry *dentry = NULL;
>>       int error;
>>
>> -     pr_debug("securityfs: creating file '%s'\n",name);
>> +     pr_debug("securityfs: creating file '%s'\n", name);
>>
>>       error = simple_pin_fs(&fs_type, &mount, &mount_count);
>>       if (error) {
>> --
>> 1.5.6.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>



-- 
Chihau Chau
