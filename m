Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0LAK1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:27:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35489 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0LAK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=TTF557FZ4KTLoM3ynq1khk20LFxaOic6Za0hT0kwhCDsTXivK+jMvgAkssIqDcW+0D
         BV+0tbbL0kQxfNoJ5DAQSwvPGTjS8A++Yrmt2VrkNE2BJP0iGZ6/OBE/i/0PMpgVQs3a
         KxP31RTqIvDg4bK5eYJCpRjn5TS8170j/+iEQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
Date: Wed, 1 Dec 2010 11:27:15 +0100
Message-ID: <AANLkTimH-aZWekLT_gAwpJ9x5GJr2Zvg_Wrj4-9aSYTi@mail.gmail.com>
Subject: Re: Atomic non-durable file write API
From: Olaf van der Spek <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 1:37 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> Since the introduction of ext4, some apps/users have had issues with
> file corruption after a system crash. It's not a bug in the FS AFAIK
> and it's not exclusive to ext4.
> Writing a temp file, fsync, rename is often proposed. However, the
> durable aspect of fsync isn't always required and this way has other
> issues.
> What is the recommended way for atomic non-durable (complete) file writes?
>
> I'm also wondering why FSs commit after open/truncate but before
> write/close. AFAIK this isn't necessary and thus suboptimal.

Is this the wrong list for this kind of question?

Greetings,

Olaf
