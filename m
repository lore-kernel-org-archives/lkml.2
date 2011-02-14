Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1BNJS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 04:18:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62071 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1BNJS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 04:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ExE6bJylzxha6RYS+hyG60b71WEIe2LNSTQtYxCMMPxTjcn4Mfa+zy/eAr5Cty17EH
         MaTxg7yXu4ewofC+9SVuJaxpdlRC9LVjPxNxcxjbkpEJ1Qaxv9HFKLp0KUUQ5ydp3v0u
         1XzMu7zMf+FOplhP3pa64TTPTJbyC7Os7tJ+8=
Subject: Re: [PATCH 09/17] t7166xb: mfd_cell is now implicitly available to
 drivers
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <20110211181101.3a4325e4@queued.net>
References: <20110211181101.3a4325e4@queued.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:17:44 +0200
Message-ID: <1297675064.2854.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 18:11 -0800, Andres Salomon wrote:
> No need to explicitly set the cell's platform_data/data_size.
> 
> Modify clients to use mfd_get_cell helper function instead of
> accessing platform_data directly.

Wold it be possible to separate out MTD-related changes?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

