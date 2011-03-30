Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1C3OKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:10:53 -0400
Received: from us-mx4.synaptics.com ([12.178.49.178]:24079 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1C3OKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:10:52 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Mar 2011 10:10:51 EDT
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 30 Mar 2011 05:46:25 -0800
From: Christopher Heiny <Cheiny@synaptics.com>
To: Joerie de Gram <j.de.gram@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <WManson@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Date: Wed, 30 Mar 2011 07:00:39 -0700
Subject: RE: [PATCH 1/3] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Thread-Topic: [PATCH 1/3] input/touchscreen: Synaptics RMI4 Touchscreen
 Driver
Thread-Index: Acvu0DAkNhune9CwTc+3niitd76RDAAEqm5E
Message-ID: <7F4B01C67BC89E4CB219B3E4BCFAE7F16BEBEF6167@USW-EX2K7-1.synaptics-inc.local>
References: <1301446249-13646-1-git-send-email-cheiny@synaptics.com>
 <1301446249-13646-2-git-send-email-cheiny@synaptics.com>,<AANLkTi=jFSrbRaAN57JxRfTyVZTCtB+3jOGPL4yLs=_w@mail.gmail.com>
In-Reply-To: <AANLkTi=jFSrbRaAN57JxRfTyVZTCtB+3jOGPL4yLs=_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoicks!  Stand by for a correction.
________________________________________
From: Joerie de Gram [j.de.gram@gmail.com]
Sent: Wednesday, March 30, 2011 4:46 AM
To: Christopher Heiny
Cc: Dmitry Torokhov; Jean Delvare; Linux Kernel; Linux Input; Allie Xiong; William Manson; Linus Walleij; Naveen Kumar Gaddipati
Subject: Re: [PATCH 1/3] input/touchscreen: Synaptics RMI4 Touchscreen Driver

Hi,

> +#include "rmi.h"

This header is missing.

Joerie
