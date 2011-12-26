Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1LZKNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 05:13:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43204 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LZKMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 05:12:52 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1324460205-24683-1-git-send-email-dg77.kim@samsung.com>
References: <1324460205-24683-1-git-send-email-dg77.kim@samsung.com>
Date: Mon, 26 Dec 2011 19:12:51 +0900
X-Google-Sender-Auth: ICrCmNJE9qfU0LqKYPHMhEpGdcU
Message-ID: <CAJ0PZbRVfhM4SPkDuEWMjesboe97Z3vFnTNgMd3OMuCvNfUk8A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] power: introduce Charger-Manager
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: cbouatmailru@gmail.com, dwmw2@infradead.org
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, Donggeun Kim <dg77.kim@samsung.com>,
        pali.rohar@gmail.com, prakity@marvell.com,
        broonie@opensource.wolfsonmicro.com, lars@metafoo.de,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 6:36 PM, Donggeun Kim <dg77.kim@samsung.com> wrote:
> Charger Manager provides in-kernel battery charger management that
> requires temperature monitoring during both normal and suspend-to-RAM states
> and where each battery may have multiple chargers attached and the userland
> wants to look at the aggregated information of the multiple chargers.
[]
> Donggeun Kim (2):
>  power: Charger-Manager: add initial Charger-Manager driver
>  power: Charger-Manager: add properties for power-supply-class

Hello Anton, David,

Could you please consider these patches for linux-2.6-battery, which
are "resend patches" of the last "RFC v2" patches of charger-manager?



Cheers! and Happy new year!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
