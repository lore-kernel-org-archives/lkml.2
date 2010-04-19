Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0DSO6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:58:43 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4913 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab0DSO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:58:42 -0400
From: Frans Pop <elendil@planet.nl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [regression] Sound not transferred to docking station after resume from StR
Date: Mon, 19 Apr 2010 16:58:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       alsa-devel@alsa-project.org
References: <201004162131.19171.elendil@planet.nl> <201004191439.45589.elendil@planet.nl> <s5hpr1vob79.wl%tiwai@suse.de>
In-Reply-To: <s5hpr1vob79.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004191658.40291.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2010 14:58:41.0342 (UTC) FILETIME=[CCAAD5E0:01CADFD0]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Takashi Iwai wrote:
> Thanks for a quick check.  But I found that the patch isn't fully
> correct.
>
> The patch below should suffice instead of the previous one.
> Could you check it again?

Works as well.

Reported-and-tested-by: Frans Pop <elendil@planet.nl>
