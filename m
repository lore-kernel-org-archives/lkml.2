Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0IMIDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:03:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10025 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab0IMIDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:03:17 -0400
Date: Mon, 13 Sep 2010 10:03:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Valdis.Kletnieks@vt.edu
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] lm75: some optimisations
Message-ID: <20100913100305.28542955@hyperion.delvare>
In-Reply-To: <30674.1284351000@localhost>
References: <1284052336-25864-1-git-send-email-shubhrajyoti@ti.com>
	<20100909175537.GA16681@ericsson.com>
	<20100909201128.3840431b@hyperion.delvare>
	<30674.1284351000@localhost>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 00:10:00 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 09 Sep 2010 20:11:28 +0200, Jean Delvare said:
> 
> > Please do NOT CC linux-kernel@vger.kernel.org. We have a mailing list
> > dedicated to hardware monitoring, there's no point to add to the 200,000
> > messages (literally) LKML gets every year. The more messages a list
> > gets, the fewer readers it has.
> 
> Any way to represent this in the MAINTAINERS file, so that people who come
> along in the fugure know that lm-sensors gets special handling in that regard?

Unfortunately not. The only way would be to convince the maintainers of
scripts/get_maintainer.pl to NOT unconditionally add LKML to its output.

-- 
Jean Delvare
