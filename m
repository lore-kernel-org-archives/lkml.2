Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1LTPsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:48:43 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60533 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1LTPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:48:31 -0500
Message-ID: <4EF0AE4A.3090509@gmail.com>
Date: Tue, 20 Dec 2011 10:48:26 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        frank.rowand@am.sony.com, jan.kiszka@web.de,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 2/5] livedump: Add the new misc device "livedump"
References: <20111220072028.9113.74876.stgit@t3500.sdl.hitachi.co.jp> <20111220072343.GC9220@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20111220072343.GC9220@t3500.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/20/11 2:23 AM), YOSHIDA Masanori wrote:
> Introduces the new misc device "livedump".
> The device only has open, close and empty ioctl operations.

When cc me, please cc whole patches. Now I don't find patch [0/5] yet.
so I haven't understand what problem do you tried to solve.

Moreover, mere 2 lines patch description is not good idea if you want
to add new device and/or new feature. Please imagine 'git log' only file
this 2 lines.
