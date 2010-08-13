Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab0HMHuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:50:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39104 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0HMHuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=t3jSArVYnVtYjmJ2mtdN6xVMU3Vj6a/oky9jLCUUtZR9NK5MV2OC7+5eRJq2JfR8PH
         BrISTlCa7g9Zn5TfQQ6x+7Cc/qP94Cp30p/CdXnAtnW3KcH+3Twvor1PQk5+Uq30Cg64
         c+fujoaP2PmQw/E9uYhJQ8+gjOuLF7Mf9C4FM=
Message-ID: <4C64F928.7030305@gmail.com>
Date: Fri, 13 Aug 2010 09:50:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.36: Sound stop working
References: <201008122200.05598.thomas@m3y3r.de>	 <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>	 <s5hpqxntw64.wl%tiwai@suse.de> <4C646110.1040104@gmail.com>	 <s5hbp97ttt5.wl%tiwai@suse.de>	 <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>	 <20100812215246.GK31363@ZenIV.linux.org.uk>	 <AANLkTimesXb7Ut3aO71HjmNjV_Q53p0Jr5j4kLTwsRGh@mail.gmail.com> <1281664431.2996.60.camel@dhcp231-200.rdu.redhat.com>
In-Reply-To: <1281664431.2996.60.camel@dhcp231-200.rdu.redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 03:53 AM, Eric Paris wrote:
> I guess noone (including me) is testing sound in linux-next   :(.

Yeah, there are some people like Valdis and me who run -next based
kernels (-mm). But it got upstream too fast to react earlier. I updated
to the latest -next few days ago, Valdis with the latest mmotm release 2
days ago. So I think these things need to sit in -next a bit longer than
they usually do. The reason is also that I need to solve 2-3 issues with
every -next update and it takes time too.

regards,
-- 
js
