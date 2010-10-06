Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab0JFGTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:19:09 -0400
Received: from smtp.nokia.com ([147.243.1.47]:29988 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0JFGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:19:08 -0400
Date: Wed, 6 Oct 2010 09:17:55 +0300
From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, cbou@mail.ru
Subject: Re: [PATCH 0/2] minor changes to power_supply
Message-ID: <20101006061755.GB32277@esdhcp041123.research.nokia.com>
References: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 09:51:36AM +0200, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> Both of them only concern USB charging.
> 
> Heikki Krogerus (2):
>   power_supply: add types for USB chargers
>   power_supply: Introduce maximum current property
> 
>  drivers/power/power_supply_sysfs.c |    4 +++-
>  include/linux/power_supply.h       |    6 +++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)

Anton, ping. Any comments on these?

-- 
heikki
