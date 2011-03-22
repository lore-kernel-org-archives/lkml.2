Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1CVSVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:21:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41324 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1CVSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OXJFs9oQMICg9sAyKiXmO+tYpON2yFIg70BM92QQzTe3ET2I/0YXTjDxsu9waSUqX8
         o7xXhdbjcxbpdOPbbWvwFvlKnybZmG0FjLrg59bqE/4JMyyAyftlenTyX2aMX1Avs1j7
         dzceVPMJqN0N0Nf/qVP08900rSgwADbkrUEx8=
MIME-Version: 1.0
In-Reply-To: <f4a301c8c917e98f44bd380aa94a51c3c4750f1c.1300794846.git.viresh.kumar@st.com>
References: <f4a301c8c917e98f44bd380aa94a51c3c4750f1c.1300794846.git.viresh.kumar@st.com>
Date: Tue, 22 Mar 2011 11:21:44 -0700
X-Google-Sender-Auth: GufPrQ6Ze5ahgK4u5H6dzEXC2bQ
Message-ID: <AANLkTimLexUQrfHFgUcQiy_D1qdcGY=WoOxpAyofD-CF@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/dmatest: Pass timeout via module params
From: Dan Williams <dan.j.williams@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, shiraz.hashim@st.com, armando.visconti@st.com,
        amit.goel@st.com, ajay.khandelwal@st.com, linux-kernel@vger.kernel.org,
        viresh.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 4:57 AM, Viresh Kumar <viresh.kumar@st.com> wrote:
> When we try to test all channels present on our controller together, some
> channels of lower priority may be very slow as compared to others. If number of
> transfers is unlimited, some channels may timeout and will not finish within 3
> seconds. Thus, while doing such regress testing we may need to have higher value
> of timeouts. This patch adds support for passing timeout value via module
> parameters. Default value is 3 msec, a negative value means max timeout
> possible.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Applied, thanks.

--
Dan
