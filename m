Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0ITMLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 08:11:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:41510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab0ITMLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 08:11:39 -0400
Message-ID: <4C974F78.4020202@suse.cz>
Date: Mon, 20 Sep 2010 14:11:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Junio C Hamano <junio@pobox.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
        Li Zefan <lizf@cn.fujitsu.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
References: <7vhbhmxyeb.fsf@alter.siamese.dyndns.org> <20100919095419.GC25704@merkur.ravnborg.org> <7v8w2xy4pq.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7v8w2xy4pq.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.9.2010 20:21, Junio C Hamano wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
>> On Sat, Sep 18, 2010 at 07:25:32PM -0700, Junio C Hamano wrote:
>>> In 60f33b8 (kconfig: get rid of stray a.o, support ncursesw, 2006-01-15),
>>> support to link menuconfig with ncursesw library was added.  To compute
>>> the linker command option -l, we check "libncursesw.{so,a,dylib}" to allow
>>> ncursesw to be used as a replacement ncurses.  However, when checking what
>>> header file to include, we do not check /usr/include/ncursesw directory.
>>>
>>> Add /usr/include/ncursesw to the list of directories that are checked.
>>> With this patch, on my Debian Lenny box with libncursesw5-dev package but
>>> not libncurses5-dev package, I can say "make menuconfig".
>>>
>>> Signed-off-by: Junio C Hamano <gitster@pobox.com>
>>
[...]
> 
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Thanks; is it my responsibility to follow-up the thread with identical
> patch with updated Subject and with your Ack, hoping somebody in kbuild
> team would pick it up?

I fixed the subject line myself and applied it to kbuild-2.6.git#kconfig.

Thanks,
Michal
