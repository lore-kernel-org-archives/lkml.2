Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1HWPIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:08:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51464 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1HWPIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA873C669E4D7@AVEXMB1.qlogic.org>
References: <4E4E2B2A.40100@odi.ch> <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
 <5E4F49720D0BAD499EE1F01232234BA873C669E4D7@AVEXMB1.qlogic.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 23 Aug 2011 11:07:40 -0400
Message-ID: <CAF_S4t8A6H7Z5cGPTHLcC05W1fWGTM0CJU=r-3GDSbmBc6L1JQ@mail.gmail.com>
Subject: Re: contention on long-held spinlock
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
        =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 08:59, Chad Dupuis <chad.dupuis@qlogic.com> wrote:
> Hi Bryan,
>
> Could you provide some configuration details and system log files?  It would help us start to pinpoint where the problem may lie.

Hi,

Ortwin was the one with the problem originally - not me. I just added
maintainer CCs to try to get the message to the right place - I don't
even have the hardware in question :)

Thanks,

Bryan
