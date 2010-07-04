Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0GDL3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 07:29:34 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51335 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0GDL3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 07:29:33 -0400
Date: Sun, 4 Jul 2010 13:29:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>, Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Iain <selsinork@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, lars4910@hotmail.com,
       birdie@permonline.ru, jadcock@cox.net, binximeng@gmail.com
Subject: Re: [PATCH v4 2/2] hwmon: Add support for W83667HG-B to w83627ehf
 driver
Message-ID: <20100704132930.75405ef5@hyperion.delvare>
In-Reply-To: <1278195202-2683-3-git-send-email-guenter.roeck@ericsson.com>
References: <1278195202-2683-1-git-send-email-guenter.roeck@ericsson.com>
	<1278195202-2683-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sat, 3 Jul 2010 15:13:22 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/hwmon/w83627ehf |   15 +++++++++----
>  drivers/hwmon/w83627ehf.c     |   42 ++++++++++++++++++++++++++++++++--------
>  2 files changed, 43 insertions(+), 14 deletions(-)

Looks very good, no objection. I'll pick this patch in my tree.

-- 
Jean Delvare
