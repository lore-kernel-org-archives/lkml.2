Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab1FVSGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:06:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56681 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488Ab1FVSGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Uhy5+s596r6dY31LFVmS6YHKRIOHJ9XRl2XFkgl19gwbWjuihuMNJGve6LXBGHHI+l
         X2scX/uUjEYrNdenzvhB3/F1OfQA9ZUaJydpOKZY6xc7rGtnPgRMhYOC9gw69fkPVI60
         yjzqlL8ztd25EiyCuVr8RyjgR6WOJU8WUe4vs=
MIME-Version: 1.0
In-Reply-To: <20110622110034.89ee399c.akpm@linux-foundation.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110622110034.89ee399c.akpm@linux-foundation.org>
Date: Wed, 22 Jun 2011 14:06:34 -0400
Message-ID: <BANLkTimPMnuoBRT9897hc-qBttyRZn46+A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Josh Boyer <jwboyer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 2:00 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:>
> I have a couple of thoughts here:
>
> - If this patchset is merged and a major user such as google is
>  unable to use it and has to continue to carry a separate patch then
>  that's a regrettable situation for the upstream kernel.
>
> - Google's is, afaik, the largest use case we know of: zillions of
>  machines for a number of years.  And this real-world experience tells
>  us that the badram patchset has shortcomings.  Shortcomings which we
>  can expect other users to experience.
>
> So.  What are your thoughts on these issues?

Has Google submitted patches for their implementation?

josh
