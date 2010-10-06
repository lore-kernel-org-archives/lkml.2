Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab0JFNrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:47:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34641 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0JFNrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:47:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MyRtzgz2wIM7B30eFbMBkGgXOlf5PlDquWd7zqa3RDHXTp7x5j4/Y8Yvqb6rTFpV5X
         TBfV5W8br1+UQ0v0E7zHnCsbdJ8lGyDL+A85uEPGdY8MCOMnDmVKckRicR3Bp4hIVdLC
         aGqNaep/vGdRNWO0pBrvZbt4gSNxdGKQV2yZQ=
Date: Wed, 6 Oct 2010 17:47:11 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] minor changes to power_supply
Message-ID: <20101006134711.GC16839@oksana.dev.rtsoft.ru>
References: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 10:51:36AM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> 
> Both of them only concern USB charging.
> 
> 
> Heikki Krogerus (2):
>   power_supply: add types for USB chargers
>   power_supply: Introduce maximum current property
> 
>  drivers/power/power_supply_sysfs.c |    4 +++-
>  include/linux/power_supply.h       |    6 +++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)

Both applied, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
