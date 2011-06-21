Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1FUTDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:03:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43501 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab1FUTDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:03:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110621185356.GJ23234@n2100.arm.linux.org.uk>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <4E00E3D2.6050602@firmworks.com> <BANLkTiny9xDwiUww9Ys+jQZ0SHdQATABUA@mail.gmail.com>
 <20110621185356.GJ23234@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 21 Jun 2011 13:02:48 -0600
X-Google-Sender-Auth: seMYdn4FubZ_3QIlqRabbmA3pU8
Message-ID: <BANLkTikHTSgowpUhMCcOMXk_oQd4Ue7S3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mitch Bradley <wmb@firmworks.com>, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:53 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jun 21, 2011 at 12:42:14PM -0600, Grant Likely wrote:
>> On Tue, Jun 21, 2011 at 12:32 PM, Mitch Bradley <wmb@firmworks.com> wrote:
>> > I wonder if it makes sense to create a new device node "/linux-devices" to express a desired mapping from device nodes to /dev entries?  The properties could be the names of device special files and the values the corresponding node phandles.
>>
>> I've been trying /really/ hard to avoid doing something like that
>> because a lot of the time the desired Linux dev name is a
>> implementation detail, and a potentially unstable one at that.  If
>> Linux requires certain devices to have certain names because that is
>> how it hooks up clocks
>
> As I keep on saying, we don't _have_ to have to match on device name.
> If DT can come up with a better way to bind a clock to a particular
> device/connection name then DT can provide its own clk_get()
> implementation which does that.

Sorry, I overstated the situation.  My point is only that I don't want
encode how Linux currently views the world into the DT, because
implementation details can and do change.

g.
