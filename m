Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1AOLKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 06:10:37 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46214 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab1AOLKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 06:10:36 -0500
X-Sasl-enc: YIFpTkmUVohEjjQ7+v+gnJYJtBhzToCdBqlw2zMx/xCO 1295089834
X-User-Agent: K-9 Mail for Android
References: <1295005953-12173-1-git-send-email-viresh.kumar@st.com> <4D304A84.1000601@fastmail.fm> <AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com> <20110114160508.41105533.akpm@linux-foundation.org>
In-Reply-To: <20110114160508.41105533.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend] fs/eventpoll.c: fix compilation warning
From: Jack Stone <jwjstone@fastmail.fm>
Date: Sat, 15 Jan 2011 11:10:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
CC: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Message-ID: <d67da8d3-b7fd-4fef-8490-a028fe41cf43@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrew Morton" <akpm@linux-foundation.org> wrote:
>I've looked at this warning several times - the code is non-buggy and
>it's a bit sad to add extra instructions unnecessarily.  It would be
>better to make this warning go away by cleaning up or restructuring the
>code.  
>
>And the code _is_ pretty stupid.  If timed_out is set to 1 then the
>function does a great pile of useless junk.  I had a quick tinkle, made
>things worse and gave up:

[snip]

>I think the attempt to munge the "timeout==0" spacial case into the
>main body of the polling loop was a mistake, and that the code would be
>better/cleaner if that special case was handled quite separately.

I can have a go at a patch later on today if you wish.

Thanks,

Jack


-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
