Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1ASCI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 21:08:27 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:34769 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1ASCIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 21:08:25 -0500
Message-ID: <4D36481E.2090708@wytron.com.tw>
Date: Wed, 19 Jan 2011 10:10:38 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "W.A. GOOSSENS" <waltergoossens@home.nl>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: Antw:Re: [PATCH] alter_ps2: Add devicetree support
References: <72c0b97741a709.4d35bf01@home.nl>
In-Reply-To: <72c0b97741a709.4d35bf01@home.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Walter,

On 01/18/2011 11:25 PM, W.A. GOOSSENS wrote:
> I can however create a "fallback" rule were unkown components are just
> added with the names the sopcinfo file, but that should not be the
> default in my opinion since this will very effectively polute the
> namespace in an uncontrolable way.

Great! Do you have proposed name with version for ps2, altera_spi and 
oc_tiny_spi? Then I can work on driver update. I guess we should ground 
the version with "1.0" in driver match table.

Cheers,
Thomas
