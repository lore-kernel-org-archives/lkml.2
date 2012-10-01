Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2JAWvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:51:25 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:46907
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab2JAWvY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:51:24 -0400
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <506A0BFB.60606@pierre-beck.de>
Date: Mon, 1 Oct 2012 16:46:20 -0600
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <2A7CFE69-08F3-4C53-928C-A94907027CAC@colorremedies.com>
References: <87mx0lsv4d.fsf@spindle.srvr.nix> <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> <87r4pslpau.fsf@spindle.srvr.nix> <506A0BFB.60606@pierre-beck.de>
To: Linux RAID <linux-raid@vger.kernel.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2012, at 3:33 PM, Pierre Beck wrote:
> It's particularly annoying when in RAID and the disk could've simply been kicked within few seconds. Something that needs improvement IMHO.

Except that while this helps with faster recovery, you're now degraded. You wouldn't want this "fast recovery" behavior if you're at your critical number of disks remaining or you lose the array upon a few seconds worth of subsequent problems. So we kinda need context specific behavior.


Chris Murphy