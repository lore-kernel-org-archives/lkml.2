Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab1ATEz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:55:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58710 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1ATEz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DoDbMtNemoGHtUfr68E9JrIsbIg4ZPIU0D09Gg6rHb0O/dR1yrHcBVJgLybNqeEjnt
         aIWN7XjGc+1EArSk/vpn7JVGDYSjK8/IqxtYNVEgQbv4YJjp1DJIRF9JeyJCJAn6qJZ2
         O6QgqFFwbB8UB5a0U1uA4dZM9wPOgrHlEmgeU=
MIME-Version: 1.0
In-Reply-To: <4D37BDE4.1000104@suse.de>
References: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G@mail.gmail.com>
	<4D37BDE4.1000104@suse.de>
Date: Wed, 19 Jan 2011 22:55:54 -0600
Message-ID: <AANLkTin7jRk6S2XWcRineCtazQb3rgYsBPakV513Ph9n@mail.gmail.com>
Subject: Re: CIFS related seg fault (v2.6.37)
From: Steve French <smfrench@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Peter Teoh <htmldeveloper@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:45 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> (Cc linux-cifs@vger.kernel.org)
>
> On 01/20/2011 07:05 AM, Peter Teoh wrote:
>> Filed a bug today:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=27082
>>
>> Version of kernel (linus git tree synced):   v2.6.37-3737-g0c21e3a
>>
>> Output of dmesg summarized here:
>>
>> [ 7273.369563] ------------[ cut here ]------------
>> [ 7273.369575] kernel BUG at fs/dcache.c:1358!
>
> Looks like the issue is already fixed in VFS (see discussion):
>        http://thread.gmane.org/gmane.linux.kernel.cifs/2284
>
> Jeff: Looks like the issue is reproducible with 2.6.37 too.. Any idea
> which is the commit that fixes this problem and whether it has been
> marked for -stable?

So Jeff's change referenced (to fs/cifs/dir.c) above is not needed due
to a vfs change?



-- 
Thanks,

Steve
