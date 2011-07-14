Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1GNWDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:03:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36621 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1GNWDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:03:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:x-system-of-record;
	b=BgUZnEAMGVEtLvJgbK3p0oXvA/DPvKW/l6qYwlEqQ2wItf1QnXa9CiRurmKtDDSKm
	+OrYHP8AWWqlXgIiDVZmQ==
MIME-Version: 1.0
In-Reply-To: <1310680445.27864.58.camel@gandalf.stny.rr.com>
References: <28585.1310602685@neuling.org> <1310604019-10935-1-git-send-email-sonnyrao@chromium.org>
 <1310612277.27864.5.camel@gandalf.stny.rr.com> <10011.1310614483@neuling.org>
 <1310647558.27864.19.camel@gandalf.stny.rr.com> <23957.1310679516@neuling.org>
 <1310680445.27864.58.camel@gandalf.stny.rr.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Thu, 14 Jul 2011 15:03:28 -0700
X-Google-Sender-Auth: t313FVbXboODsPdZO5-mx2Z_yZw
Message-ID: <CAPz6YkWcvU3pnsOfT0RKurpkrLMEy9Jkz_SuiPaE_Rf+iFbFHA@mail.gmail.com>
Subject: Re: [PATCH] [RFCv3] perf: robustify proc and debugfs file recording
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Neuling <mikey@neuling.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 2:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-07-15 at 07:38 +1000, Michael Neuling wrote:
>
>> > Hmm, your patch has some serious issues caused by your mail client. When
>> > saving (or looking at the raw message) I get this:
>>
>> Crap, sorry.
>>
>> This is the same mail client I've used for sending patches for donkeys
>> years so something much have under the covers with a distro upgrade or
>> some such.
>
> Even after fixing it, I had really strange issues with using my script
> to pull it in with git am. I kept getting this strange error about the
> patch header missing or something. Don't have it anymore as I just
> finally did it by manually git am (error), apply patch by hand, git add,
> git am resolve, which seemed to do the trick.
>
> -- Steve

Apologies for all the problems... I had tested it and it built but obviously
I screwed up somewhere.  Thanks for looking at it

Sonny
