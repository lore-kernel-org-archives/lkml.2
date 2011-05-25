Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1EYWLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:11:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58588 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1EYWLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BcNSrsGe8DSsku3aOL2W826v5emo8WvMus7CbDJaoiXmcc+Z5MC2jXmz5wZLUs+YgW
         5zWEmzn8kL0CHDpu/QjjE5R96+yz+Z68PiLr4G2brdMCcq7hsv/ok/2cHry/h/fPxfdd
         gcqOTJK2ViyvJJSMJ2dptundPSP2QGFYalTNs=
MIME-Version: 1.0
In-Reply-To: <BANLkTinbw6pZjhMscfXFMArd=XU=VC=+eQ@mail.gmail.com>
References: <m1wrhh3z62.fsf@fess.ebiederm.org> <BANLkTikW4vJbC8kcLSKuemUBbu36SO6hwg@mail.gmail.com>
 <20110525213806.GA4590@mail.hallyn.com> <BANLkTinbw6pZjhMscfXFMArd=XU=VC=+eQ@mail.gmail.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Thu, 26 May 2011 00:11:25 +0200
Message-ID: <BANLkTinPTRxmCPhsrqq9fr1veqiNgns_zQ@mail.gmail.com>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
To: C Anthony Risinger <anthony@xtfx.me>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 C Anthony Risinger <anthony@xtfx.me>:
> On Wed, May 25, 2011 at 4:38 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> Quoting C Anthony Risinger (anthony@xtfx.me):
[...]
>>> if i understand correctly, mount namespaces (for example), allow one
>>> to build such constructs as "private /tmp" and similar that even
>>> `root` cannot access ... and there are many reasons `root` does not
>>> deserve to completely know/interact with user processes (FUSE makes a
>>> good example ... just because i [user] have SSH access to a machine,
>>> why should `root`?)
>> If for instance you have a file open in your private /tmp, then root
>> in another mounts ns can open the file through /proc/$$/fd/N anyway.
>> If it's a directory, he can now traverse the whole fs.
> aaah right :-( ... there's always another way isn't there ... curse
> you Linux for being so flexible! (just kidding baby i love you)
>
> this seems like a more fundamental issue then?  or should i not expect
> to be able to achieve separation like this?  i ask in the context of
> OS virt via cgroups + namespaces, eg. LXC et al, because i'm about to
> perform a massive overhaul to our crusty sub-2.6.18 infrastructure and
> i've used/followed these technologies for couple years now ... and
> it's starting to feel like "the right time".

You either trust the admin or don't use the machine. There is no third way.

Best Regards,
Michał Mirosław
