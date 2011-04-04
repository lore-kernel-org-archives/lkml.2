Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1DDCIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 22:08:01 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:60346 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753582Ab1DDCIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 22:08:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Message-ID:Date:From:Organization:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SQxUhigGqp24x/cs3bGpC8dESdH5YNlLSdMjiJsi1R8q6avXSouG6oIm85mQC44pUtAAXlzSN13aXDZbyEugNovKitjLaeuIN51yXYcKiA3aiCX+Fy0SFxyo5xTDE073;
Message-ID: <4D9927FF.5010806@xenotime.net>
Date: Sun, 03 Apr 2011 19:07:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] x86, defconfig: replace ext3 with ext4
References: <20110401074548.17629.77638.stgit@localhost6> <20110403132208.GC5141@quack.suse.cz>
In-Reply-To: <20110403132208.GC5141@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 64.134.136.44 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/2011 6:22 AM, Jan Kara wrote:
> On Fri 01-04-11 11:45:48, Konstantin Khlebnikov wrote:
>> Replace ext3 with ext4, because now it is a de facto standard file system.
>> And set CONFIG_EXT4_USE_FOR_EXT23=y to use it also for mounting ext2/ext3.
>    I'm sorry but I think it's too early for CONFIG_EXT4_USE_FOR_EXT23 part.

I considered the date of the email and then just ignored it.  ;)

