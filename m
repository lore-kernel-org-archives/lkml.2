Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1GAKpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:45:08 -0400
Received: from relay01-haj2.antispameurope.com ([83.246.65.51]:58325 "EHLO
	relay01-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab1GAKpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:45:06 -0400
Message-ID: <4E0DA2EC.1000407@iis.fraunhofer.de>
Date: Fri, 01 Jul 2011 12:35:24 +0200
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com> <1309486707-1658-11-git-send-email-nroyer@invensense.com> <4E0D8DC7.6060108@cam.ac.uk>
In-Reply-To: <4E0D8DC7.6060108@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.07.2011 11:05, Jonathan Cameron wrote:
> Hang on, so your motion processing unit takes in a pressure sensor?
> Interesting....
>
> Manuel, am I imagining things or did you have a driver for one of these?
Yes, indeed we have one for bmp085. I have to update it for the latest 
API, but these are things I'm going to do during the next 2 month.

Regards,

-- 
Manuel Stahl
Fraunhofer-Institut IIS
Leistungsoptimierte Systeme

Nordostpark 93
D90411 Nürnberg
Telefon  +49 (0)911/58061-6419
Fax      +49 (0)911/58061-6398
E-Mail   manuel.stahl@iis.fraunhofer.de

http://www.iis.fraunhofer.de
http://www.smart-power.fraunhofer.de

