Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1CRDXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:23:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59800
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759Ab1CRDXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:23:41 -0400
Date: Thu, 17 Mar 2011 20:24:19 -0700 (PDT)
Message-Id: <20110317.202419.189703451.davem@davemloft.net>
To: slapin@ossfans.org
Cc: alan@lxorguk.ukuu.org.uk, linux-x25@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow LAPB users know which data were actually sent.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110318005220.GA9674@build.ihdev.net>
References: <1300400422-8820-1-git-send-email-slapin@ossfans.org>
	<20110317235532.44c0e202@lxorguk.ukuu.org.uk>
	<20110318005220.GA9674@build.ihdev.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Lapin <slapin@ossfans.org>
Date: Thu, 17 Mar 2011 20:52:20 -0400

> I implement accessor for special equipment (acessing fiscal information)
> which uses custom protocol over LAPB. As it is being implemented,
> I actually wanted to know if this approach for using LAPB is good enough
> for mainline submission, as I want to have kernel part to be in mainline.
> I think I will have the rest of patches ready within two weeks.

Submit the infrastructure for inclusion when you're user is completed
and submittable as well.

Thanks.
