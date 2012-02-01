Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2BARkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:40:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49802 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2BARkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:40:07 -0500
Date: Wed, 1 Feb 2012 21:40:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: =?utf-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        =?utf-8?B?6rmA64+Z6re8?= <dg77.kim@samsung.com>
Subject: Re: [PATCH] power_supply: Fix modalias for charger-manager
Message-ID: <20120201174002.GC12255@oksana.dev.rtsoft.ru>
References: <10819991.146571326280997005.JavaMail.weblogic@epml24>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10819991.146571326280997005.JavaMail.weblogic@epml24>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:23:17AM +0000, 함명주 wrote:
> Written by Axel Lin<axel.lin@gmail.com>
> > Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
> > modalias is prefixed with "platform:".
> > Current code has the id_table, thus add MODULE_DEVICE_TABLE will
> > automatically setup the modalias.
> > 
> > Also make charger_manager_id static as it is only used in this driver.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Thanks.
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
