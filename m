Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0ITRFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:05:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab0ITRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:05:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 0/2] PM / Hibernate: Default image size computation and comment fix
Date: Mon, 20 Sep 2010 19:04:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201009150021.45101.rjw@sisk.pl>
In-Reply-To: <201009150021.45101.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201904.03602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 15, 2010, Rafael J. Wysocki wrote:
> Hi,
> 
> The following two patches fix a comment in the hibernate memory preallocation
> code and make the default image size depend on the total RAM size.  I regard
> them as 2.6.37 material.
> 
> Please let me know if there are any objections.

OK, no response means no objections to me. :-)

I'm putting the two patches in this series into suspend-2.6/linux-next.

Thanks,
Rafael
