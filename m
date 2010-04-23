Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0DWQhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:37:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64828 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0DWQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:37:14 -0400
Message-ID: <4BD1CC5C.7000702@oracle.com>
Date: Fri, 23 Apr 2010 09:35:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Chihau Chau <chihau@gmail.com>
CC: jmorris@namei.org, eparis@redhat.com, viro@zeniv.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: inode: Fix code style issues
References: <1271983035-26401-1-git-send-email-chihau@gmail.com>	 <20100423085021.b54f98c5.randy.dunlap@oracle.com> <s2jf5ca57691004230910nfac5a247ta691c07b71b4d7e1@mail.gmail.com>
In-Reply-To: <s2jf5ca57691004230910nfac5a247ta691c07b71b4d7e1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BD1CCB2.0189:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/10 09:10, Chihau Chau wrote:
> Hi Randy,
> 
> 2010/4/23 Randy Dunlap <randy.dunlap@oracle.com>:
>> On Thu, 22 Apr 2010 20:37:15 -0400 Chihau Chau wrote:
>>
>>> From: Chihau Chau <chihau@gmail.com>
>>>
>>> This fixes two code style issues:
>>>
>>> - A space required after that close brace '}'
>>
>> Why?  do we say that somewhere?
>>
> 
> I was used the checkpatch.pl script written by Dave Jones, Joel Schopp
> and Andy Whitcroft.

OK, thanks for the explanation.
That would be correct for something like:

	if (foo_bar) {
		do_this();
		do_that();
	} else {
		pr_err("fatal error");
		panic("help");
	}

but I don't think that it's needed for nested data structures.


>>
>>>
>>> - A space required after that ','
>>>
>>> Signed-off-by: Chihau Chau <chihau@gmail.com>
>>> ---
>>>  security/inode.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/security/inode.c b/security/inode.c
>>> index c3a7938..f875f47 100644
>>> --- a/security/inode.c
>>> +++ b/security/inode.c
>>> @@ -124,7 +124,7 @@ static inline int positive(struct dentry *dentry)
>>>
>>>  static int fill_super(struct super_block *sb, void *data, int silent)
>>>  {
>>> -     static struct tree_descr files[] = {{""}};
>>> +     static struct tree_descr files[] = { {""} };
>>>
>>>       return simple_fill_super(sb, SECURITYFS_MAGIC, files);
>>>  }
>>> @@ -208,7 +208,7 @@ struct dentry *securityfs_create_file(const char *name, mode_t mode,
>>>       struct dentry *dentry = NULL;
>>>       int error;
>>>
>>> -     pr_debug("securityfs: creating file '%s'\n",name);
>>> +     pr_debug("securityfs: creating file '%s'\n", name);
>>>
>>>       error = simple_pin_fs(&fs_type, &mount, &mount_count);
>>>       if (error) {
>>> --
>>> 1.5.6.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
> 
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
