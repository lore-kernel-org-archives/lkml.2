Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0FYMuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:50:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab0FYMuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:50:22 -0400
Message-ID: <4C24A606.5040001@suse.de>
Date: Fri, 25 Jun 2010 18:20:14 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
 register them
References: <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com>
In-Reply-To: <9822.1277312573@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 10:32 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> Define inode-level data storage objects (managed by cifsInodeInfo structs).
>> Each inode-level object is created in a super-block level object and is
>> itself a data storage object in to which pages from the inode are stored.
>>
>> The inode object is keyed by UniqueId. The coherency data being used is
>> LastWriteTime and the file size.
> 
> Isn't there a file creation time too?

I think the creation time is currently being ignored as we won't be able
to accomodate in POSIX stat struct.

> I take it you don't support caching on files that are open for writing at this
> time?
> 

Yes.


-- 
Suresh Jayaraman
