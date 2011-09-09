Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab1IIOPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:15:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab1IIOO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:14:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qFTo0WbCHVW2nuav1gasyRJpCeFgCXgk/JQ6hn6bgg7YDgIVR5uYU/OjKBqzR7AM3
	wndXoljFwyInxtdSvlzDA==
MIME-Version: 1.0
In-Reply-To: <20110823211510.GA17729@polaris.bitmath.org>
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
 <1314011163-19098-5-git-send-email-djkurtz@chromium.org> <4E52C252.9060904@canonical.com>
 <201108221405.15767.dmitry.torokhov@gmail.com> <20110823211510.GA17729@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 9 Sep 2011 22:14:36 +0800
X-Google-Sender-Auth: 0ExTXU4HiNeYLORzAa7soukyqLM
Message-ID: <CAGS+omDXDmUvmCWWBEF6vrBurGFShLoNMk11JYKHM=sR=8S9+g@mail.gmail.com>
Subject: Re: [PATCH 4/9 v5] Input: synaptics - add image sensor support
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, Aug 24, 2011 at 5:15 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> > Henrik, you commented a few times on the earlier patches, are you happy
> > with this version?
>
> Yep, the code is very clear. One could only wish the hardware sucked
> less, but that is life. Thanks Daniel for your effort.
>
>    Acked-by: Henrik Rydberg <rydberg@euromail.se>
>
> on all nine patches.
>
> Cheers,
> Henrik

Hope your house move went well.
Any idea when this patchset will be applied?

Thanks,
-Daniel
