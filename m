Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797Ab0L2FSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 00:18:05 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38527 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0L2FSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 00:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wE/I3CYln5YHJayhXXcduYLcMnPtTRBkEAqT3rBkIYb6kILL2aR3aMBbToDWLYMpEx
         CePh4hI5m95HwTVsi+d9IBqiBK/7WRRPZ2fama/6kglYLeQCQk0RtCoOxG+H2hi3qo7L
         rj059IQ2B1PdKt00pChfw5WK+UednTvlLG85s=
MIME-Version: 1.0
In-Reply-To: <201012281514.35179@zigzag.lvk.cs.msu.su>
References: <AANLkTim4zbBvTyc4hNurCmPN7GisXe1mmzR6P4aj3xzA@mail.gmail.com>
	<201012281514.35179@zigzag.lvk.cs.msu.su>
Date: Wed, 29 Dec 2010 10:48:01 +0530
Message-ID: <AANLkTimxTaimdn9wGbzqBSJU=Ekqo92YrkTuTjRKY3Gu@mail.gmail.com>
Subject: Re: Drift when measuring time using add_timer
From: Mohan V <mohanvforum@gmail.com>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 5:44 PM, Nikita V. Youshchenko <yoush@cs.msu.su> wrote:
>>            do_gettimeofday(&timeval);
>
> Try getnstimeofday() instead
>
I tried with getnstimeofday(), I am getting the same result. Anyway
getnstimeofday()
gets called from do_gettimeofday().

Thanks,
Mohan
