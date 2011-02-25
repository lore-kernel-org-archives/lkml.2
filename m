Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1BYJGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:06:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37990 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1BYJGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UwMoijXqTcbQ0fmMEpO5PAIPOnu+3JEeiNHutAnzOO/o+ZhHz/x08lMBxtN0gem+mx
         +p5Tn7SqtY1pAnp7/CJyD4icX5aBVn4mJSj6e5cOtiss7hPXPJJDlHu6Nk7bHbk5QwSw
         QlfsPtsaBFhhnA9GZK/9DD/IwKFvuK+aHPM20=
Subject: Re: [PATCH 09/29] t7166xb: mfd_cell is now implicitly available to
 drivers
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-mtd@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1297998456-7615-10-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
	 <1297998456-7615-10-git-send-email-dilinger@queued.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 11:05:12 +0200
Message-ID: <1298624712.2798.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 19:07 -0800, Andres Salomon wrote:
> No need to explicitly set the cell's platform_data/data_size.
> 
> Modify clients to use mfd_get_cell helper function instead of
> accessing platform_data directly.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Just to re-confirm, I suggest to merge these MTD changes via Samuel's
tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

