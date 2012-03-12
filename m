Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2CLRQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:16:42 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:55521 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2CLRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:16:40 -0400
Message-ID: <4F5E2F73.2000703@ge.com>
Date: Mon, 12 Mar 2012 17:16:35 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org
CC: Wim Van Sebroeck <wim@iguana.be>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/2] powerpc: Add support for GE IMP3A
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
In-Reply-To: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2012 17:16:37.0373 (UTC) FILETIME=[E1D5B2D0:01CD0073]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, forgot to correct the subject. This is v3 of the patches. I got it
right in the actual patches, just the cover letter I missed.

Martyn

On 12/03/12 17:12, Martyn Welch wrote:
> These patches add support for the GE IMP3A. This board (based on a Freescale
> P2020) uses some support for FPGA logic common with the PPC9A and other 86xx
> based boards, so this support has been moved out of the 86xx directory. A
> config option (GE_FPGA) has been added to reduce churn on dependant drivers
> (such as the watchdog timer) when further boards are added.

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
