Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1K3Tin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:38:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65079 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1K3Til convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:38:41 -0500
MIME-Version: 1.0
In-Reply-To: <20111121153716.GA16417@S2100-06.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca> <20111121153716.GA16417@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 30 Nov 2011 12:38:19 -0700
X-Google-Sender-Auth: GvEIez2F8QazOrUERvVOtGnYcsw
Message-ID: <CACxGe6teGPmgOiwSVQ_PebXo=9x8EVwjH2qQYi5LU813BvY3Ow@mail.gmail.com>
Subject: Re: [RFC 6/8] of: add clock providers
To: Shawn Guo <shawn.guo@freescale.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 8:37 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
>> +struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
>> +{
>> +     int index = 0;
>> +
>> +     if (name)
>> +             index = of_property_match_string(np, "clock-input-names", name);
>
> If it fails to match name, we may want to force 'index' back to 0.

Actually, if it fails to match, the function should fail.  Fixed.
Fixed all the editorial comments too.  Thanks.

>
> Also according to binding document above,
> s/clock-input-names/clock-input-name?  Hope you do not want to
> change binding document to get them aligned.  I have written code
> per binding document :)

I've changed to match the binding documentation.

Thanks for the review,
g.
