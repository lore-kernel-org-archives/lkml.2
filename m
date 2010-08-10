Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab0HJWEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:04:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490Ab0HJWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cwVF1C8PhyVQ7WWMqFlwdJlwZDmeGi749tKKxPvQ/Pd7lIdUWoPee2rsHm4JbK8lz3
         /JY0JpLiOkAj7lwv5pEAnw4Fxpx4Xs5BAHEaCLk4bU4YU+Bw4HkQ/6q9LlzlE63Zb5QE
         ajoh4h2nbniEoQwgKu9nWpwEdfWVSYs8jxAuY=
MIME-Version: 1.0
In-Reply-To: <4C5F9B25.8080401@st.com>
References: <4C5F9B25.8080401@st.com>
Date: Wed, 11 Aug 2010 01:04:08 +0300
Message-ID: <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
From: Felipe Contreras <felipe.contreras@gmail.com>
To: viresh kumar <viresh.kumar@st.com>, git@vger.kernel.org
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 9:07 AM, viresh kumar <viresh.kumar@st.com> wrote:
> Mail server in ST has recently changed and now we have Microsoft
> exchange server. We are using thunderbird as mail client.
> What we observed with this server is that patch are broken now while
> sending as well as receiving. Tabs are replaced by spaces and may
> be some other too which we haven't observed.
>
> Has anybody found a solution to this kind of issues? Are there any
> workarounds possible?

Same in Nokia. I wrote a script to fix exchange's crap, but I also
noticed some quoted-printable mails didn't get converted, so the
easiest would be to tell git to always send quoted-printable.

git folks: any chance of getting that feature to git send-email?

-- 
Felipe Contreras
