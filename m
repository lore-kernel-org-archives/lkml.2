Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0DSMS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:18:59 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2671 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899Ab0DSMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:18:58 -0400
From: Frans Pop <elendil@planet.nl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [regression] Sound not transferred to docking station after resume from StR
Date: Mon, 19 Apr 2010 14:18:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       alsa-devel@alsa-project.org
References: <201004162131.19171.elendil@planet.nl> <201004191338.15750.elendil@planet.nl> <s5h8w8jps9j.wl%tiwai@suse.de>
In-Reply-To: <s5h8w8jps9j.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004191418.56592.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2010 12:18:57.0420 (UTC) FILETIME=[7C3464C0:01CADFBA]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Takashi Iwai wrote:
> commit ea52bf260ecbb175339af3178c15788df21b7516
> Author: Daniel T Chen <crimsun@ubuntu.com>
> Date:   Sun Dec 27 18:48:29 2009 -0500
>
>     ALSA: hda: Add powerdown for Analog Devices HDA codecs
>
> Could you try to revert it?

Yep, that's the culprit.

Let me know if a fix needs to be tested.

Thanks,
FJP
