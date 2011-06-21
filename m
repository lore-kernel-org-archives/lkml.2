Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab1FUWw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:52:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:42612 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1FUWw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:52:57 -0400
In-Reply-To: <BANLkTikBUo3jO=R0amkdxU1V3QMJoOUkEw@mail.gmail.com>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org> <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca> <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net> <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com> <4E00F290.2010303@firmworks.com> <BANLkTik9LXTJ--fRwUBscokWraPwOZnpHA@mail.gmail.com> <4E011678.4030208@firmworks.com> <BANLkTikBUo3jO=R0amkdxU1V3QMJoOUkEw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <ba379b3b42f1659f4f6649c78b8bb1b2@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Jason Liu <jason.hui@linaro.org>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mitch Bradley <wmb@firmworks.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, patches@linaro.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Date: Wed, 22 Jun 2011 00:52:47 +0200
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, we're having an impedance mismatch.  I'm thinking specifically
> about the device tree compiler and some syntactic sugar for using the
> label definition to generate /also/ create alias properties. The
> hairiness is related to that and the way that dtc is implemented, not
> with the final aliases themselves.

You can generate DTC-style aliases from OFW-style aliases instead (or
as well), it has other advantages (like being more readable, and having
the aliases grouped together).


Segher

