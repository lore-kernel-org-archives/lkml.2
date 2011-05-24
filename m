Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1EXRxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:53:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37973 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab1EXRxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JP71pHvIfw6ZV3tUcR23M6JyYJ3F03eXnPFIf/gFG0+e5/A22i8N3mFDHP3elMyyz8
         X3KyxfZcZ89+JSoJ0JJ1S1vEgFwRYHFosRBoSteVJn4UKFRAKiCyRD850obsURH+8mSW
         tvS8xXJIVWiHzsJAtRII1OZqKB+RdQ5HcSE50=
MIME-Version: 1.0
In-Reply-To: <20110524141031.GC2276@sepie.suse.cz>
References: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
 <1306176297-6964-1-git-send-email-jim.cromie@gmail.com> <20110524141031.GC2276@sepie.suse.cz>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 24 May 2011 11:53:05 -0600
Message-ID: <BANLkTimoMJXG1jGmZcupgYEHa0Pd6d_0BA@mail.gmail.com>
Subject: Re: [PATCH 0/3 rev2] fix scripts/export_report.pl
To: Michal Marek <mmarek@suse.cz>
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 8:10 AM, Michal Marek <mmarek@suse.cz> wrote:

> Applied to kbuild-2.6.git#misc after editing the subject lines a bit:
>
> Jim Cromie (3):
>      export_report: do collectcfiles work in perl itself
>      export_report: sort SECTION 2 output
>      export_report: use warn() to issue WARNING, so they go to stderr
>
> Michal
>

thanks,

can you point to the tree ?
(I want to see what rewording is better)

I didnt see it at git.kernel.org, nor where MAINTAINERS entry points
(at least after converting it to http)

T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
for-next
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
rc-fixes
