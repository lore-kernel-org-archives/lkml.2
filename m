Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2HBOQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:16:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2HBOQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:16:09 -0400
Date: Thu, 2 Aug 2012 16:16:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v2 0/3] new USB eBeam input driver
In-Reply-To: <1343912397-18353-1-git-send-email-yann.cantin@laposte.net>
Message-ID: <alpine.LRH.2.00.1208021602250.15211@twin.jikos.cz>
References: <1343912397-18353-1-git-send-email-yann.cantin@laposte.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, Yann Cantin wrote:

> Second test-drive for a new USB input driver for eBeam
> devices.
> 
> Following Dmitry's advice, i've remove device specific infrastructure.
> 
> Currently, only the Luidia eBeam classic projection model is supported.
> 
> Patch 1 and 2 are here to let the ebeam driver be choose to handle
> the device instead of the generic-usb hid one (totally useless).

Just merge 1 and 2 together, not necessary to have two commits because of 
that.

Thanks,

-- 
Jiri Kosina
SUSE Labs

