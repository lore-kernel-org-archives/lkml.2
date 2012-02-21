Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2BUPQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:16:53 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37704 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2BUPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:16:51 -0500
Date: Tue, 21 Feb 2012 10:14:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-20
Message-ID: <20120221151435.GA19354@tuxdriver.com>
References: <20120220203740.GD6740@tuxdriver.com>
 <20120220.192324.498901675497866305.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220.192324.498901675497866305.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 07:23:24PM -0500, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 20 Feb 2012 15:37:40 -0500
> 
> > Here is another batch of fixes intended for 3.3.  Most of the fixes
> > this time are for Bluetooth.
> 
> Pulled, but please read the bluetooth changes more carefully in the
> future, there were a lot of coding style errors introduced this
> time around.

I pinged Johan about this, and he tells me that he spoke to Marcel
as well.  They were a bit unsure about the issue.  Is your concern
primarily about some excessive tabbing for indentation of parameters
and such?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
