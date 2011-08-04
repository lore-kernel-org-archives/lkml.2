Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1HDJUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:20:03 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:31016 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1HDJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:19:55 -0400
Date: Thu, 4 Aug 2011 11:16:54 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110804091654.GA31431@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
 <4E36A4EA.30404@ge.com>
 <20110801143102.GA9705@becoht-mvanga>
 <4E36CB29.2030907@ge.com>
 <20110802115434.GA25063@becoht-mvanga>
 <4E381043.7080501@ge.com>
 <4E390CAB.20305@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E390CAB.20305@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> Whilst it would be nice to be able to change the bus numbering, I don't think
> that passing numbers into the bridge driver at load time is the correct approach.

Depends on the problem we are trying to solve :P

This patch fixes the issue with multiple bridges of different types in a simple way
(which is currently an issue for us).

The UUID method would be more "complete" and solve the issues with multiple bridges
of the same type but I think we can apply this one till we have an implementation
for it. What do you think?

Thanks!

--
/manohar
