Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2KXU21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 15:28:27 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55462 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab2KXU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 15:28:26 -0500
Message-ID: <1353788903.1420.38.camel@x61.thuisdomein>
Subject: Re: [PATCH 22/24] MAINTAINERS: fix BAST
From: Paul Bolle <pebolle@tiscali.nl>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Vincent Sanders <vince@simtec.co.uk>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>
Date: Sat, 24 Nov 2012 21:28:23 +0100
In-Reply-To: <1353716808-16375-23-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
	 <1353716808-16375-23-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2012 20:28:24.0690 (UTC) FILETIME=[40E4AD20:01CDCA82]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 22:26 -0200, Cesar Eduardo Barros wrote:
> These files were renamed by commit 85fd6d6 (ARM: S3C2410: move
> mach-s3c2410/* into mach-s3c24xx/).

I submitted an identical patch in https://lkml.org/lkml/2012/6/25/154 .
In a reaction on that patch Kukjin Kim wondered whether "Simtec Linux
Team and Vincent are still supporting BAST". No-one bothered to reply on
Kukjin's message, which suggests BAST is unsupported and this entry
might as well be dropped entirely.


Paul Bolle

