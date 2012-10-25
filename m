Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946064Ab2JYOkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:40:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945971Ab2JYOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:40:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: viresh kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Make uapi/linux/irqnr.h non-empty
Date: Thu, 25 Oct 2012 14:40:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alessandro Suardi <alessandro.suardi@gmail.com>,
        Michal Marek <mmarek@suse.cz>, "spear-devel" <spear-devel@list.st.com>,
        Olof Johansson <olof@lixom.net>
References: <20121015161401.17133.8590.stgit@warthog.procyon.org.uk> <CA+55aFy1c1Pn_czRoyybCGCsT89Rc7-kHfNCnH9xvc=p=1jrkQ@mail.gmail.com> <CAOh2x=m=6fpzPVAS2wx9J-0rKpXVJar1sXnEsn7pA0g3KsmRgA@mail.gmail.com>
In-Reply-To: <CAOh2x=m=6fpzPVAS2wx9J-0rKpXVJar1sXnEsn7pA0g3KsmRgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251440.03044.arnd@arndb.de>
X-Provags-ID: V02:K0:FoSP/cwHcjagcETPbSkgsXaMgQYAOqvXM/VudWhlp5Z
 GL2IWwic6G1kJVks0BIdh44aDFJK1q+ucUK6XX9KqeRUa0Omr+
 biFlsDdhZN1YDYcvHfe8RnhLj+LHMhwnaUlcjsu/StBpa78Mqu
 a1NmY4By/Nvu4j7Sv3NinE0L11xS0bSTNCm5SSKjPUg2jDY9MU
 ljWM8pBpn1hxfjzguHs447CIlJh59v08d76e/trFg2jd1unlh2
 DVtFw7gjOWiPTkdHa1QmpHQ/cfTJmlc0J4TAGTL3MmgJo9LQQK
 7CBsVQkxu0dYz6MicHp087UUjIy6SD/sVQRB97gD1E6adzC0En
 pWPo6Cw7CzvDtNaZJFhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2012, viresh kumar wrote:
> commit b31e23726bb9d6cd8848fc539b23330769830110
> Author: Viresh Kumar <viresh.kumar@st.com>
> Date:   Thu Apr 19 22:23:13 2012 +0530
> 
>     SPEAr13xx: Add header files
> 
> Don't know how they got added, obviously my fault :)
> But nobody could even catch them in reviews.
> 
> Remove them.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Sorry for the delay. Olof has been handling the arm-soc patches in the recent
weeks, but he wasn't on Cc on this mail, so he missed it and I didn't look
closely.

I've applied it in the fixes branch now and will send it together
with the next round of arm-soc bug fixes. Please make sure you always
use the arm@kernel.org alias or have both Olof and me on Cc when submitting
patches for arm-soc.

Thanks for the reminders!

	Arnd
