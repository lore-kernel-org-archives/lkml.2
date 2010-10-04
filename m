Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab0JDQuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:50:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42684 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0JDQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=DC9tv3qvOAFjzzAdB8GY1nBy7cFG7sLASVbsOB+3mWebfBXXr4EYwzVzGYT1uo4iGe
         zMSK8qQpuvX6QbAUnZ4j7Ju7mLqzbVXoWSYcXqQrlLF886pYZsHt0zZm5lVB3VxqRSDQ
         jAHicINO0uqxUWiEYVuIvATrs0JnYPurUhfrY=
MIME-Version: 1.0
In-Reply-To: <20101004154633.GA2900@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	<20101004154633.GA2900@redhat.com>
Date: Mon, 4 Oct 2010 17:49:59 +0100
X-Google-Sender-Auth: 1l-5yMiBFsjbhoOejNxYi45xrFY
Message-ID: <AANLkTimz+SqG6COfkcyP9vquKusLs3KFix1mdw+_1sZt@mail.gmail.com>
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Daniel Drake <dsd@laptop.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2010 16:46, Jason Baron <jbaron@redhat.com> wrote:
> looks like I moved dynamic no-op selection way too early in the boot -
> before the exception tables required to select invalid opcodes were
> even set up. The patch belows moves them later and should resolve this
> issue for you. thanks for narrowing it down!

Applied this without the earlier patches from Borislav.

Thanks, that fixes it.

Daniel
