Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0GEPX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 11:23:57 -0400
Received: from poutre.nerim.net ([62.4.16.124]:53760 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0GEPX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 11:23:56 -0400
Date: Mon, 5 Jul 2010 17:23:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Iain <selsinork@gmail.com>, binximeng@gmail.com, jadcock@cox.net,
       Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Ethan Lawrence <e.law87@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>, birdie@permonline.ru,
       lars4910@hotmail.com
Subject: Re: [lm-sensors] [PATCH v4 1/2] hwmon: w83627ehf driver cleanup
Message-ID: <20100705172353.3effa134@hyperion.delvare>
In-Reply-To: <20100705135900.457764e7@hyperion.delvare>
References: <1278195202-2683-1-git-send-email-guenter.roeck@ericsson.com>
	<1278195202-2683-2-git-send-email-guenter.roeck@ericsson.com>
	<20100704132442.07a5ef40@hyperion.delvare>
	<20100704135010.GA21500@ericsson.com>
	<20100705135900.457764e7@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jul 2010 13:59:00 +0200, Jean Delvare wrote:
> I have no further objections to your patch, so I'll apply it now. Then
> I'll publish the patches and update the stand-alone driver, and we can
> call for testers.

Standalone driver is available for testing:
http://khali.linux-fr.org/devel/misc/w83667hg/

-- 
Jean Delvare
