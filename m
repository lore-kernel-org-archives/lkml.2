Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0KYPrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:47:33 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:54090 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab0KYPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:47:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 09/12] media: Entity locking and pipeline management
Date: Thu, 25 Nov 2010 16:47:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        sakari.ailus@maxwell.research.nokia.com, lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-10-git-send-email-laurent.pinchart@ideasonboard.com> <20101125135351.GD24208@opensource.wolfsonmicro.com>
In-Reply-To: <20101125135351.GD24208@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251647.45488.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 25 November 2010 14:53:51 Mark Brown wrote:
> On Thu, Nov 25, 2010 at 03:28:16AM +0100, Laurent Pinchart wrote:
> > Link states must not be modified while streaming is in progress on a
> > graph they belong or connect to. The entity locking API helps drivers
> > enforcing that requirement.
> 
> This is not desirable for embedded audio - for example, it is very
> common to wish to switch from headphone to speaker and back mid
> playback, or to move between headset, speakerphone and handset modes on
> a phone.  This is normally implemented by reconfiguring the output paths
> at runtime without interrupting applications.

Agreed. The locking should be made optional. I'll work on that.

-- 
Regards,

Laurent Pinchart
