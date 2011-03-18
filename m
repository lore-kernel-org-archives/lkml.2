Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1CRLU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:20:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62174 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1CRLUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=US/OY8zGE5L8eXxBvLaS0LfdxZUHustUpDdVjn/mbaqHnq3L3+CkVpRcY8jlp7XyV8
         tDaqXk+RkwqVSiRoERdCdLAc8BfiIlN4Dgkg8HKIC+gUF1L7QJ7s57BETaNFKW0KeAiN
         duX6CGOqJZjl3brv6M7SIvhO3zi1Xk1L2xpi0=
MIME-Version: 1.0
In-Reply-To: <20110318102232.GA30751@elte.hu>
References: <20110316205204.GA2686@kroah.com> <1300309888-5028-1-git-send-email-gregkh@suse.de>
 <1300309888-5028-5-git-send-email-gregkh@suse.de> <20110317175607.GD2648@redhat.com>
 <20110317180204.GA15205@suse.de> <20110318102232.GA30751@elte.hu>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 18 Mar 2011 12:19:09 +0100
X-Google-Sender-Auth: K_ucByDqGAJswh1Cn0lRkyw0YlU
Message-ID: <AANLkTimGYXTNDrP5wJGzc_bPNcOFdoMCVLR=z2KQmNgB@mail.gmail.com>
Subject: Re: [PATCH 05/50] Dynamic debug: Add more flags
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Jason Baron <jbaron@redhat.com>,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Greg Banks <gnb@fmeh.org>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Preferably it should have been merged through him. That would also have alerted
> him to the conflict potential and would have concentrated all changes in a
> single tree, as it really should happen ...
>
> So could you *please* do such changes in a bit more organized fashion in the
> future? Please use the get_maintainer script:
>
>  $ scripts/get_maintainer.pl -f lib/dynamic_debug.c
>
>  Jason Baron <jbaron@redhat.com> (commit_signer:6/10=60%)
>  Thomas Renninger <trenn@suse.de> (commit_signer:3/10=30%)
>  Pekka Enberg <penberg@cs.helsinki.fi> (commit_signer:3/10=30%)
>  Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:3/10=30%)
>  Steven Rostedt <rostedt@goodmis.org> (commit_signer:2/10=20%)
>  linux-kernel@vger.kernel.org (open list)
>
> The majority of those gents were not Cc:-ed to any of the submissions and
> resubmissions.

This patch was posted for the first time a few months ago. The
get_maintainer.pl script back then listed the names of Greg Banks and
Konrad Rzeszutek Wilk as the first two. If the get_maintainer.pl
script output had been as informative back then as it is now, the
right people would have been CC-ed.

Bart.
