Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2HVP3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:29:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51196 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab2HVP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:29:19 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 22 Aug 2012 08:29:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/radio/shark2: Fix build error caused by missing
 dependencies
Message-ID: <20120822152922.GA6177@roeck-us.net>
References: <1345648585-5176-1-git-send-email-linux@roeck-us.net>
 <5034F932.4000405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5034F932.4000405@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 05:22:26PM +0200, Hans de Goede wrote:
> Hi,
> 
> I've a better fix for this here:
> http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.6
> 
> I already send a pull-req for this to Mauro a while ago, Mauro?
> 
Looks like it found its way into mainline in the last couple of days.
Should have updated my tree first. Sorry for the noise.

Guenter
