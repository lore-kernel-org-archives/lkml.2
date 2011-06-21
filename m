Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1FUW7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:59:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49351 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1FUW7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <ba379b3b42f1659f4f6649c78b8bb1b2@kernel.crashing.org>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com> <4E00F290.2010303@firmworks.com>
 <BANLkTik9LXTJ--fRwUBscokWraPwOZnpHA@mail.gmail.com> <4E011678.4030208@firmworks.com>
 <BANLkTikBUo3jO=R0amkdxU1V3QMJoOUkEw@mail.gmail.com> <ba379b3b42f1659f4f6649c78b8bb1b2@kernel.crashing.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 21 Jun 2011 16:58:50 -0600
X-Google-Sender-Auth: YGC3YDitkzPT1XwlI7vg1Lljrhk
Message-ID: <BANLkTinmahnoJ2Rip2jzP=tt6wrhRQN3sA@mail.gmail.com>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, Mitch Bradley <wmb@firmworks.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 4:52 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>> Ah, we're having an impedance mismatch.  I'm thinking specifically
>> about the device tree compiler and some syntactic sugar for using the
>> label definition to generate /also/ create alias properties. The
>> hairiness is related to that and the way that dtc is implemented, not
>> with the final aliases themselves.
>
> You can generate DTC-style aliases from OFW-style aliases instead (or
> as well), it has other advantages (like being more readable, and having
> the aliases grouped together).

There is no difference between OFW and DTC aliases as far as I'm aware.

g.
