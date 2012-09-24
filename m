Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2IXIEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:04:14 -0400
Received: from antcom.de ([188.40.178.216]:40517 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab2IXIEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:04:12 -0400
Message-ID: <506013F7.20404@antcom.de>
Date: Mon, 24 Sep 2012 10:04:07 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: arnd@arndb.de, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] video: Remove pnx4008 driver
References: <1345991001-32462-1-git-send-email-stigge@antcom.de> <1345991001-32462-2-git-send-email-stigge@antcom.de> <505F6436.3050009@gmx.de>
In-Reply-To: <505F6436.3050009@gmx.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 09/23/2012 09:34 PM, Florian Tobias Schandinat wrote:
> On 08/26/2012 02:23 PM, Roland Stigge wrote:
>> This patch removes the video driver for pnx4008. The architecture is being
>> removed via the arm-soc tree.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Applied as it doesn't make sense to keep it around if there is no
> architecture left that can use it. Though I didn't get any technical
> reason why the architecture is removed at all, just reasons why it might
> be okay to do so. But it doesn't matter as I don't have to decide this
> anyway.

Right, there are no formal technical reasons, except that we are forward
porting this architecture+video driver for years now without any
indication that the changes were actually tested successfully. No known
current users, even in the development community. And it takes resources
developing the related architecture lpc32xx because of drivers shared
between the two.

Thanks,

Roland
