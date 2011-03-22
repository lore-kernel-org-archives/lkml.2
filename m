Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1CVOPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:15:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60917 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1CVOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:15:12 -0400
Date: Tue, 22 Mar 2011 10:14:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Fries <david@fries.net>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfcomm/core.c avoid dangling pointer, check session
Message-ID: <20110322141403.GA2512@tuxdriver.com>
References: <20110322023810.GG22204@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322023810.GG22204@spacedout.fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 09:38:10PM -0500, David Fries wrote:
> rfcomm_process_sessions is calling rfcomm_process_rx, but
> in this case the session is closed and freed leaving a
> dangling pointer that blows up when rfcomm_process_rx returns
> and rfcomm_process_dlcs is called with the now dangling session
> pointer.

Please trim this commit log substantially before the patch is merged...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
