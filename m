Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab1BRWdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:33:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55140 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1BRWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:33:40 -0500
Date: Fri, 18 Feb 2011 22:33:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [alsa-devel] [PATCH v9 01/12] media: Media device node support
Message-ID: <20110218223337.GC25168@sirena.org.uk>
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686067-9666-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297686067-9666-2-git-send-email-laurent.pinchart@ideasonboard.com>
X-Cookie: Opened for inspection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 01:20:56PM +0100, Laurent Pinchart wrote:

> +	  Enable the media controller API used to query media devices internal
> +	  topology and configure it dynamically.
> +
> +	  This API is mostly used by camera interfaces in embedded platforms.

I'd expect this comment is going to bitrot very soon once the framework
goes in.
