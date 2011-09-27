Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1I0SZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:25:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38862 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1I0SZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110927181420.GQ4289@opensource.wolfsonmicro.com>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
	<20110921124936.GA25620@sirena.org.uk>
	<CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
	<20110921131637.GF4374@opensource.wolfsonmicro.com>
	<CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
	<20110927150555.GF20588@ponder.secretlab.ca>
	<CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
	<20110927181420.GQ4289@opensource.wolfsonmicro.com>
Date: Tue, 27 Sep 2011 19:25:03 +0100
X-Google-Sender-Auth: B06m2kV6uxMWOggX452i70mS9Iw
Message-ID: <CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 7:14 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Sep 27, 2011 at 05:44:04PM +0100, Daniel Drake wrote:
>
>> However, it does take Mark's suggestion into account that the mfd
>> should have some clear representation in the device tree. For us it
>> already did have (naturally), but this wasn't reflected in my earlier
>> patch. It is now - the location of the vx855-gpio node is based on
>> finding the mfd node and going from there.
>
> Why not just kmemdup() the template you're using rather than modifying
> it in place?

Could do, but is there any point in this case? I'm not seeing it. The
"template" is already being modified in this way in the current driver
as well.

Daniel
