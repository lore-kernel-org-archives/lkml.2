Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2AQTy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:54:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62424 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2AQTy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:54:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFzuvYm2pHZP--=nx3qGatzgfT6Dii49gzJwzxOtzniTg@mail.gmail.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<4F15CC56.90309@redhat.com>
	<CAOJsxLFzuvYm2pHZP--=nx3qGatzgfT6Dii49gzJwzxOtzniTg@mail.gmail.com>
Date: Tue, 17 Jan 2012 21:54:27 +0200
X-Google-Sender-Auth: WThxvw5GsEpk1af3xSld6SjCsXQ
Message-ID: <CAOJsxLG-4uDCiB7XoF=hkATYCcu2+mJqbjCNekYNt0hywkhrEw@mail.gmail.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:49 PM, Pekka Enberg <penberg@kernel.org> wrote:
> That said, I'd really like to see the N9 and Android policies
> supported with this ABI. It's much easier to make it generic once we
> support real-world use cases.

If people are interested in hacking on the thing, I pushed the commit
in 'vmnotify/core' branch of

    git://github.com/penberg/linux.git

                        Pekka
