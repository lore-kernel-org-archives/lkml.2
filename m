Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1EKPu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:50:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:21139 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab1EKPuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:50:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,352,1301900400"; 
   d="scan'208";a="745610387"
Date: Wed, 11 May 2011 10:10:22 +0100
From: Alan Cox <alan@linux.intel.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110511101022.7f6e583b@bob.linux.org.uk>
In-Reply-To: <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
References: <20110510212038.GA3279@patrik-macbook>
	<20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
	<BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> pipes and LVDS only finds a bogus mode of 0x0 pixels. Not sure why
> LVDS takes over instead of SDVO since it has valid modes, but my
> screen just goes into powersave when no proper PLL can be set for the
> bogus mode.

Well that is hopeful. If we get a bogus 0x0 pixel mode it means it did
detect something invalid but for some reason we didn't punt on it.

Alan
