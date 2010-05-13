Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab0EMNEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 09:04:55 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:48542 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753949Ab0EMNEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 09:04:53 -0400
Date: Thu, 13 May 2010 09:04:49 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: T500 cdrom drive never stops spinning until mount.
Message-ID: <20100513130448.GA1967@elliptictech.com>
Mail-Followup-To: Robert Hancock <hancockrwd@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20100512023549.GA22623@cpu18.student.cs>
 <4BEB4FA3.70308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEB4FA3.70308@gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:02 Wed 12 May     , Robert Hancock wrote:
> Is something like hal, devicekit, etc. accessing the drive in this case? 
> Can you try a minimal boot with no unnecessary processes and see if the 
> same thing happens?

Good call, booting with init=/bin/zsh and sure enough, the cd drive
spins down.  Looks like udev is causing the constant spin-ups, so I'll
post to linux-hotplug instead.

Sorry for the noise,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
