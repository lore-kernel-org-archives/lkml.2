Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1JNVzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:55:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1JNVzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:55:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HK6NQNE308HdYJBYQx9ia92A09wgG4Ge1l3F1UCgz9H7S3TbWXOyn6FYpksArAcwl
	4/qdGdPRhCMi03SLlbBXg==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110141127240.14768@pobox.suse.cz>
References: <1318548517-5289-1-git-send-email-tlambert@chromium.org>
	<alpine.LNX.2.00.1110140134200.14768@pobox.suse.cz>
	<CAA_E9NHi4mS+J5VrxS915S3TD-157D=hMG7b-PMT2c1RYvnwVQ@mail.gmail.com>
	<alpine.LNX.2.00.1110141127240.14768@pobox.suse.cz>
Date: Fri, 14 Oct 2011 14:55:34 -0700
X-Google-Sender-Auth: h0YWOGz-jkGC6lw2dwUicGC8Mj4
Message-ID: <CAA_E9NH3eD+PaAc0jBDj6EnuU7sHbFyhKobhbCXPW7z6nBJwBg@mail.gmail.com>
Subject: Re: [PATCH] Driver for Primax keyboards violating USB HID spec
From: Terry Lambert <tlambert@chromium.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no problem doing that; I'll rework the patch.

Thanks!
-- Terry

On Fri, Oct 14, 2011 at 2:30 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> On Thu, 13 Oct 2011, Terry Lambert wrote:
>
> > Hi Jiri; thanks for looking so promptly!
> >
> > The routine right now just caches the hi->input for later look up
> > during the raw input report, which I suppose could be done inline on
> > each report with a couple function calls.
>
> Well yes, but even in px_raw_event() the px_device *px is only
> initialized, but never used. So I'd just remove the whole px_device thing
> altogether, I don't think it's needed.
>
> > I don't have one of the folding keyboards people are complaining about
> > not being able to use for Android tablets on hand, or the unhappy Dell
> > Inspiron laptop, both of which use the controller   That's to explain
> > why the remapping code and the product ID for them are missing from
> > this patch.
>
> I see.
>
> I'd like to ask you though to only submit patches containing code that is
> actually used. Whenever the remapping part is needed for some other
> keyboard, we'll just add it at the very time it's needed.
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
