Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2BCMvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 07:51:39 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:38782 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2BCMvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 07:51:38 -0500
X-Greylist: delayed 1050 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Feb 2012 07:51:37 EST
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] fs/vfat: add *.cmd to filenames listed as executable by mount option "showexec"
References: <20120203064055.GA7184@mobil.systemanalysen.net>
	<8762foe543.fsf@devron.myhome.or.jp>
	<20120203095550.GA12435@mobil.systemanalysen.net>
Date: Fri, 03 Feb 2012 21:34:03 +0900
In-Reply-To: <20120203095550.GA12435@mobil.systemanalysen.net> (Roland
	Eggner's message of "Fri, 3 Feb 2012 10:55:50 +0100")
Message-ID: <871uqcdrk4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Eggner <edvx1@systemanalysen.net> writes:

> On 2012-02-03 Fr 16:41:16 +0900, OGAWA Hirofumi wrote:
>> Roland Eggner <edvx1@systemanalysen.net> writes:
>> 
>> > The mount option "showexec" provides a somewhat more native view of vfat
>> > filesystems: only filenames *.exe *.com *.bat are listed as
>> > executable, rather
>> > than all files.  This patch adds filenames *.cmd to those listed
>> > as executable.
>> > *.cmd are usually scripts associated with the shell "cmd.exe",
>> > which has been
>> > the default shell in several OS versions of its vendor.
>> >
>> > Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
>> > ---
>> 
>> Hm, this may be good for someone, but this may not be for someone. So,
>> this probably should be option if someone really care it.
>> 
>> I'm not thinking about how though...
>> 
> Think of VM images of recent versions of the FAT originating OS:  currently
> "showexec" will miss roughly half of the files, for which it is intended for.
> IMHO this patch provides a very cheap completion of a feature of the vfat kernel
> module.  Cheap in terms of only 9 characters additional source code.
>
> If you really see an advantage in the current, incomplete state of the
> "showexec" feature, compared to the proposed, completed state:  please elaborate
> your objection.

You would be happy with adding "cmd", and may think enough. But Someone
is not happy with it. And someone want to add "sh", "py", and "pl".

If I have to tackle it, why I have to make happy only your state? I'm
not saying current has advantage, I'm saying your patch doesn't make
guys happy like current one. It is just moving a place of happiness from
a group to an another group, right?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
