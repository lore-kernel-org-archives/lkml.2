Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1JYL5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:57:41 -0400
Received: from smtp.net4visions.de ([85.214.69.78]:44492 "EHLO
	smtp.net4visions.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1JYL5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:57:39 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.602
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 13:57:17 +0200
From: Markus Kolb <linux-201011@tower-net.de>
To: <linux-kernel@vger.kernel.org>
Cc: <Valdis.Kletnieks@vt.edu>
Subject: Re: Question to directory setgid bit FS implementation details
In-Reply-To: <15714.1319534364@turing-police.cc.vt.edu>
References: <af8d5834d1bfb5f19aaf7deba6caa1a0@mail.net4visions.de>
 <15714.1319534364@turing-police.cc.vt.edu>
Message-ID: <6d74828ba3d3350978233ddb54b4fdc0@mail.net4visions.de>
User-Agent: net4VISIONS Webmail/1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 05:19:24 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 25 Oct 2011 10:55:55 +0200, Markus Kolb said:
>
>> can you please explain in brief how the creation of files
>> in directories with setgid bit set is implemented in
>> filesystems.
>
> Look in fs/inode.c, function inode_init_owner(). All of 8 lines of 
> code.

Ok.
Looks for me that there are only changes in data structs.

To be on the safe side can you confirm that there should be no call
inside the kernel code to change the effective group of a process
which creates a file in a directory with setgid-bit set?!

Thanks
