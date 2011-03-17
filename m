Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1CQWsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:48:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35632 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab1CQWsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nxnzmqPBak4amx3rlLq2IJHtXQVo9nyt1jFKMGI8ACKJ+HFV32AOdfxaxYqdQ8ALsr
         53BlKf8KxxXiuwkHwWp0WTyF+FGErGg4J79F21KzR2J8oFEvKv1c0/BQ+jUzYZuO1yWW
         I63cGlBAG59h15hYmVy4+WctFxuqIf2jDEwRc=
MIME-Version: 1.0
In-Reply-To: <20110317224252.GC22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
	<AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
	<20110317072344.GZ22723@ZenIV.linux.org.uk>
	<AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
	<20110317104434.GB22723@ZenIV.linux.org.uk>
	<4d827eae305473e2bf@agluck-desktop.sc.intel.com>
	<20110317224252.GC22723@ZenIV.linux.org.uk>
Date: Thu, 17 Mar 2011 15:48:13 -0700
Message-ID: <AANLkTim5pj0J4VaYRzK8_8fpb0=hO5yxhAL48egiTE2e@mail.gmail.com>
Subject: Re: Some fixes for pstore (Was Re: [git pull] mnt_devname queue)
From: Tony Luck <tony.luck@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 3:42 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> +     memcpy(private->data, data, size);
>> +     inode->i_size = private->size = size;
>>
>>       inode->i_private = private;
>
> Better move that before d_add()

Will do.

> *blink*
>        if (IS_ERR(root))
>                return root;
>        return root;
>
> ... or am I misreading the patch?

Your patch reading skills are fine ... the code deserves more than a *blink*.
Will fix.

-Tony
