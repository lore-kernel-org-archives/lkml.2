Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1EZGTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:19:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49334 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1EZGTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=waggEXwSmQqIqP9B+/H3fGRSQY1a1Ya+H7ZKgB9k/1+1U0szo8S7sPpq4dSv0wQs+O
         ruEXwxMg6ZQQ+2V/yeL5twPYjhdQtCqD+9ZpeO39m6vVJ0On9wfamIdNWibho59xWgM8
         nYnXr68aNsIiNcmwKQnQZmo9Q6k3vb21wkte8=
Message-ID: <4DDDF0D0.6090805@gmail.com>
Date: Wed, 25 May 2011 23:18:56 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: no sound in current -git
References: <20110526013423.GA25226@redhat.com> <4DDDD47C.5030504@gmail.com> <20110526043337.GA11224@redhat.com> <20110526051109.GA11870@redhat.com>
In-Reply-To: <20110526051109.GA11870@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 10:11 PM, Dave Jones wrote:
> On Thu, May 26, 2011 at 12:33:38AM -0400, Dave Jones wrote:
>
>   >   >  sound over here is out as well on a macbook pro. seems gnome shell
>   >   >  didn't like whats being merged with the current Mainline i.g. no sound
>   >   >  bluetooth applet missing. will bisect when I get a chance.
>   >
>   >  Maybe it was this that just got merged..  (building now)
>   >
>   >  commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
>   >  Author: Eric Paris<eparis@redhat.com>
>   >  Date:   Wed May 25 19:49:18 2011 -0700
>   >
>   >      tmpfs: fix XATTR N overriding POSIX_ACL Y
>
> Yep. That fixes sound for me.
> Sorry for the false alarm Takashi!
>
> 	Dave
>
>

hmm.. pulled and noticed the above with git log, then did git revert for 
the above, built, but still no sound. will do a bisect in the morning or 
later on.

last good kernel is:
2.6.39-02667-g71a8638
so the bisect shouldn't take too long(but then again!)

Justin P. Mattock
