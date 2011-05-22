Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1EVQ5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 12:57:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41378 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1EVQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 12:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vE33FdOy3yyZ1L+aYinZadzw/WGEq6yI133L2yl1HeNyLmqj1XP+mf5TSz5lTMq7Yl
         Ebc+t0gUkFqHmFgqE081H9H1547C5aaa78Se7xXN/KQAHqhIaJV4GC9Kd4JelqkguUUE
         5HgFz5FjznEX9vvpMG/ObDIMAvglWroqxD7XI=
Message-ID: <4DD94054.3010003@garzik.org>
Date: Sun, 22 May 2011 12:56:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alex Bligh <alex@alex.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
References: <10C5890F8F477E959B993BFA@nimrod.local> <20110520122010.GA25628@infradead.org> <60FB7C5F40961417F1605595@nimrod.local> <20110522104448.GA20241@infradead.org>
In-Reply-To: <20110522104448.GA20241@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 06:44 AM, Christoph Hellwig wrote:
> And btw, I'd like to know what makes sync_file_range so tempting,
> even after I added documentation explaining why it's almost always
> wrong to use it to the man page.

Because Linus used it to describe how to stream data to disk, such as 
what MythTV does.  Example: 
http://lkml.indiana.edu/hypermail/linux/kernel/0904.0/01076.html

