Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1ASRBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:01:46 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:35614 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab1ASRBp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:01:45 -0500
MIME-Version: 1.0
In-Reply-To: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
References: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
Date: Wed, 19 Jan 2011 11:01:44 -0600
Message-ID: <AANLkTi=Q4dnDC9hJNUbegKY6arHQbyJs_92DLDJ8MX7u@mail.gmail.com>
Subject: Re: [PATCH 0/2] staging: tidspbridge for 2.6.38
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Jan 13, 2011 at 11:34 PM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> Set of important changes for 2.6.38, to fix a critical bug (1) and a
> compile break (2).
>
> Guzman Lugo, Fernando (1):
>  staging: tidspbridge: configure full L1 MMU range
>
> Omar Ramirez Luna (1):
>  staging: tidspbridge: replace mbox callback with notifier_call
>
>  drivers/staging/tidspbridge/core/tiomap3430.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)

Ping... to include these critical fixes, I made a correction on my
patch and sent v2, please let me know if you want me to send the two
patches again.

Regards,

Omar
