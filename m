Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0FTN3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 09:29:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64131 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0FTN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 09:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xQztvfl61TURsYDUqwVH1r3DEdPqT0inTJfTBwLUJ747DlOeYgKGobCp6S5CSWfV15
         W9Ktu1eWpi7/NeeUdpa2lZ60bEbXGT/5YYb4LY8P6+3da2nlJqpuottWF/FNasTqlAgQ
         cI7gJyxA2ndM2FUpSjWcaNaQqkcCbYwqcvGW4=
Message-ID: <4C1E17A0.8010202@gmail.com>
Date: Sun, 20 Jun 2010 06:29:04 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alessandro Guido <ag@alessandroguido.name>
CC: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       linux-audit@redhat.com
Subject: Re: [PATCH 3/6]cifs Fix variable not set warnings
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com> <1276288869-16815-4-git-send-email-justinmattock@gmail.com> <4C1E1602.7080700@alessandroguido.name>
In-Reply-To: <4C1E1602.7080700@alessandroguido.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 06:22 AM, Alessandro Guido wrote:
>> ...
>> @@ -734,7 +733,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct
>> dentry *direntry,
>> direntry->d_op =&cifs_dentry_ops;
>> d_add(direntry, newInode);
>> if (posix_open)
>> - filp = lookup_instantiate_filp(nd, direntry, NULL);
>> /* since paths are not looked up by component - the parent
>> directories are presumed to be good here */
>> renew_parental_timestamps(direntry);
>> ...
>
> This is wrong, now "renew_parental_timestamps(direntry)" is in the if body.
>
>
>

have you had a chance to look at the later one I had sent in yesterday?
if so out of the two, which might be a better bet(keep in mind the first 
set has whitespace issues).

Justin P. Mattock
