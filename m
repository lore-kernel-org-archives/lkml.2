Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1F0Qhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:37:36 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51350 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1F0Qhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:37:32 -0400
Date: Mon, 27 Jun 2011 18:37:29 +0200
From: Bastian Blank <waldi@debian.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xen: Add alias to autoload backend drivers
Message-ID: <20110627163728.GA23028@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-devel@lists.xensource.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20110624215155.GB4735@wavehammer.waldi.eu.org>
 <20110627161327.GO6978@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110627161327.GO6978@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 12:13:27PM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 24, 2011 at 11:51:55PM +0200, Bastian Blank wrote:
> > All the Xen backend drivers are assigned to a special bus type
> > xen-backend. This allows userspace to load the modules on request.
> Is there a specific version of udev that would take advantage of this?

Was there a version within the last three years that can't? The patch is
tested and udev does its work.

Bastian

-- 
Pain is a thing of the mind.  The mind can be controlled.
		-- Spock, "Operation -- Annihilate!" stardate 3287.2
