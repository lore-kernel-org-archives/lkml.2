Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1AURyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:54:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58612 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1AURyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nuSZw7Ju/a2Rqv4YRwYOy07L1q/F+OdrkIPKaT8yI+5yRtNKEKF/oE1KUj4V2BzRo1
         pDU/5zpv1KS5mjmuMB56HGMPxAEDG3+4ALuR1ofhO+XlhSftoSO7eibPwKACmArT4AbH
         h3RJXh7S4WlHP8jKIY75WqacxvxI2KTlAXwNk=
MIME-Version: 1.0
In-Reply-To: <1295622575-18607-13-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
	<1295622575-18607-13-git-send-email-bp@amd64.org>
Date: Fri, 21 Jan 2011 09:54:20 -0800
X-Google-Sender-Auth: yjAmB5N9mhWlewaojyLhkiiJpCU
Message-ID: <AANLkTinWZr7Ps-B+YT7tZm4+1=mTOGutUWWfi9L59wra@mail.gmail.com>
Subject: Re: [PATCH] ras: Add RAS daemon
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        rostedt@goodmis.org, fweisbec@gmail.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 7:09 AM, Borislav Petkov <bp@amd64.org> wrote:
> +       format_buf = malloc_or_die(fsize);
> +       if (!format_buf)
> +               die("allocating format buffer");

You don't trust "malloc_or_die()" to make it dead enough? :-)

Will take a look through the rest of bits - looks very interesting.

-Tony
