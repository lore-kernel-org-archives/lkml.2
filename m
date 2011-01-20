Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1ATFCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:02:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1ATFCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:02:37 -0500
Message-ID: <4D37C1AE.7040100@suse.de>
Date: Thu, 20 Jan 2011 10:31:34 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
Cc: Peter Teoh <htmldeveloper@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: Re: CIFS related seg fault (v2.6.37)
References: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G@mail.gmail.com>	<4D37BDE4.1000104@suse.de> <AANLkTin7jRk6S2XWcRineCtazQb3rgYsBPakV513Ph9n@mail.gmail.com>
In-Reply-To: <AANLkTin7jRk6S2XWcRineCtazQb3rgYsBPakV513Ph9n@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 10:25 AM, Steve French wrote:
> On Wed, Jan 19, 2011 at 10:45 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
>> (Cc linux-cifs@vger.kernel.org)
>>
>> On 01/20/2011 07:05 AM, Peter Teoh wrote:
>>> Filed a bug today:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=27082
>>>
>>> Version of kernel (linus git tree synced):   v2.6.37-3737-g0c21e3a
>>>
>>> Output of dmesg summarized here:
>>>
>>> [ 7273.369563] ------------[ cut here ]------------
>>> [ 7273.369575] kernel BUG at fs/dcache.c:1358!
>>
>> Looks like the issue is already fixed in VFS (see discussion):
>>        http://thread.gmane.org/gmane.linux.kernel.cifs/2284
>>
>> Jeff: Looks like the issue is reproducible with 2.6.37 too.. Any idea
>> which is the commit that fixes this problem and whether it has been
>> marked for -stable?
> 
> So Jeff's change referenced (to fs/cifs/dir.c) above is not needed due
> to a vfs change?
> 

Sorry it was not a VFS fix but a fix from Al Viro that fixed this
problem. IIUC, the commit has made it to cifs-2.6.git but not upstream.

commit 1c929cfe6d8f2087a337a868fbf6c38d56bb4889
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Dec 18 11:43:51 2010 -0500

    switch cifs



-- 
Suresh Jayaraman
