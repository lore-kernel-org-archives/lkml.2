Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0ELNTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:19:16 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:49368 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814Ab0ELNTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:19:15 -0400
Date: Wed, 12 May 2010 09:19:12 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: T500 cdrom drive never stops spinning until mount.
Message-ID: <20100512131912.GA27273@elliptictech.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20100512023549.GA22623@cpu18.student.cs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512023549.GA22623@cpu18.student.cs>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:35 Tue 11 May     , Nick Bowler wrote:
> Mounting the disk also causes it to stop spinning (and it remains
> stopped after unmounting it).

Sorry, this was a lie.  As soon as the disk spins up again after
unmounting (or if it was unmounted while still spinning), it will
continue to spin forever.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
