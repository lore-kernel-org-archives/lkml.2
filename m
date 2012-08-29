Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2H2RCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:02:10 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53148 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab2H2RCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:02:08 -0400
Message-ID: <1346259706.3935.2.camel@cumari.coelho.fi>
Subject: Re: [PATCH 3.6-rc3] wlcore: Declare MODULE_FIRMWARE usage
From: Luciano Coelho <coelho@ti.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 29 Aug 2012 20:01:46 +0300
In-Reply-To: <1346251689-37023-1-git-send-email-tim.gardner@canonical.com>
References: <1346251689-37023-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-29 at 08:48 -0600, Tim Gardner wrote:
> Cc: Luciano Coelho <coelho@ti.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Eliad Peller <eliad@wizery.com>
> Cc: Arik Nemtsov <arik@wizery.com>
> Cc: Eyal Shapira <eyal@wizery.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---

Please add a proper commit message.  And there's no need to put all
these people in Cc: in the commit log.  CC'ing when sending the patch is
enough (even though for such small patch, the linux-wireless mailing
list and myself is enough).

--
Luca.

