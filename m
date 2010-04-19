Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0DSMjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:39:51 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4183 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab0DSMju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:39:50 -0400
From: Frans Pop <elendil@planet.nl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [regression] Sound not transferred to docking station after resume from StR
Date: Mon, 19 Apr 2010 14:39:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       alsa-devel@alsa-project.org
References: <201004162131.19171.elendil@planet.nl> <s5h8w8jps9j.wl%tiwai@suse.de> <s5h633nprjy.wl%tiwai@suse.de>
In-Reply-To: <s5h633nprjy.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004191439.45589.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2010 12:39:45.0683 (UTC) FILETIME=[643A3630:01CADFBD]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Takashi Iwai wrote:
> Or how about the patch below?

That fixes the problem too.

Please add my:
Reported-and-tested-by: Frans Pop <elendil@planet.nl>

Cheers,
FJP
