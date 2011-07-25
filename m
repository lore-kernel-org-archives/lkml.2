Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab1GYJOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:14:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1GYJOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:14:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:x-system-of-record;
	b=k8qk2umNPGxeyXAkWb2D6EJj6p3BHX5gpYTI+7UqE6cigHxD6m9nBe0MGAWPtrQ0l
	WNCWx/3cKRf7illfdjYtA==
MIME-Version: 1.0
In-Reply-To: <20110725082918.GC22937@core.coreip.homeip.net>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-9-git-send-email-djkurtz@chromium.org> <20110725082918.GC22937@core.coreip.homeip.net>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 25 Jul 2011 17:14:22 +0800
X-Google-Sender-Auth: 9YEIrU4Q_pGtLuc5EK2RqOR5jOc
Message-ID: <CAGS+omAQmb-q6xC-Gh6z69iNNyr=rN-Khsq90aCHJwe-6F9ANw@mail.gmail.com>
Subject: Re: [PATCH 8/9 v2] Input: add BTN_TOOL_QUINTTAP for reporting 5
 fingers on touchpad
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rydberg@euromail.se, chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 4:29 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Wed, Jul 20, 2011 at 09:39:05PM +0800, djkurtz@chromium.org wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> >
>
> Do we know what we want to do with this gesture? Because if not I'd
> rather not merge it for now, until there are real users.

And do what instead?
Report 5 fingers with BTN_TOOL_QUADTAP?

> Thanks.
>
> --
> Dmitry
