Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0CTJSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 05:18:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46297 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0CTJSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 05:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pyiBb7eEIWxwcl6IhWLngfRm9VldGnYrzL37DPUifZyA0XRm9sF5GqvmecMN1/CWb1
         0B5uDOefb8WF9AdA2Kr+8/aSPT1PoBLy/fBp9WMTTfjle6pY8oF/zyr5ujkyjAshLMHM
         CRdCd0eAR2TNfIIr+D+xbGufMft9cBle0zTOg=
MIME-Version: 1.0
In-Reply-To: <201003192353.o2JNrPR0019366@imap1.linux-foundation.org>
References: <201003192353.o2JNrPR0019366@imap1.linux-foundation.org>
Date: Sat, 20 Mar 2010 10:18:05 +0100
Message-ID: <8aa016e11003200218i1f5fa5d1sd1eb21ab76f7b0d1@mail.gmail.com>
Subject: Re: + kernel-user-remove-unreachable-code.patch added to -mm tree
From: Dhaval Giani <dhaval.giani@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, jslaby@suse.cz, a.p.zijlstra@chello.nl,
       mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 20, 2010 at 12:53 AM,  <akpm@linux-foundation.org> wrote:
>
> The patch titled
>     kernel/user: remove unreachable code
> has been added to the -mm tree.  Its filename is
>     kernel-user-remove-unreachable-code.patch
>
> Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
>
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: kernel/user: remove unreachable code
> From: Jiri Slaby <jslaby@suse.cz>
>
> The code which executed this code was removed in 7c9414385ebfdd87cc542
> (sched: Remove USER_SCHED).  Remove the dangling code too.
>

This one is already fixed and merged via http://lkml.org/lkml/2010/3/16/210 .

Thanks,
Dhaval
