Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2IMWCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:02:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46235 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab2IMWCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:02:17 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4FA419E87744DF4DAECD5BCE1214B7A919D52325@ORSMSX108.amr.corp.intel.com>
References: <1347500288.7434.1.camel@phoenix> <CAF+7xW=1wJjDHeRSqBHNQuyOkuDrn0J1Eypg9BMAxA=Np5SwLg@mail.gmail.com>
 <4FA419E87744DF4DAECD5BCE1214B7A919D52325@ORSMSX108.amr.corp.intel.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 14 Sep 2012 06:01:56 +0800
Message-ID: <CAF+7xWnUkj4BiKzF_izq=4ki2YAW7Wn4frwERLvVRhROYBnpRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-sensor-hub: Clear HID_CLAIMED_INPUT bit earlier
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jonathan Cameron <jic23@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/14 Pandruvada, Srinivas <srinivas.pandruvada@intel.com>:
> Hi Axel,
>
> We don't need this anymore as when connect_mask is 0, the hid_connect will not be called.
> So we don't need hdev->claimed = HID_CLAIMED_INPUT anymore.
>

Okay. I'm going to resend the patch for this serial.
Axel
