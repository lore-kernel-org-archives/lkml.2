Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1CXJdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:33:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63844 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab1CXJdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PLty+wgkzk7a6hojSwsC2NY23avFvbyFbq1uQT9A21qXUPLWkx13KRoEyFD6uXMflT
         ppci/NxLE9dz68pPMv7o68ndD6i750z/zxWwJWaxPXJEaWNN5OtjKITsNKqcmwc0FBME
         3ZCADCDn1++AqoC65pXsKV9DcJnwKg/nAm4UY=
MIME-Version: 1.0
In-Reply-To: <20110324084819.GH30812@elte.hu>
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
	<20110324084819.GH30812@elte.hu>
Date: Thu, 24 Mar 2011 12:33:32 +0300
Message-ID: <AANLkTik+M3jnwa0eYjMMZQOz6Y3WANQqYvzNb15+Cp4A@mail.gmail.com>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 24, 2011, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Don, I've added yours SOB, ok? (The patch is attached to avoid
>> space/tabs problem
>> due to web-mail client)
>
> The patch lacks a proper description about the motivation and effects of the
> patch.
>
> Thanks,
>
>         Ingo
>

Ok, i'll resend more detailed description later, thanks.
