Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0IVLgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:36:40 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:37422 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0IVLgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:36:39 -0400
Message-ID: <4C99EA3D.7050405@csr.com>
Date: Wed, 22 Sep 2010 12:36:29 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] uwb: fix device_register() error handling
References: <1284900918-24770-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284900918-24770-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2010 11:36:30.0171 (UTC) FILETIME=[665E0AB0:01CB5A4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov wrote:
> If device_register() fails then call put_device().
> See comment to device_register.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: David Vrabel <david.vrabel@csr.com>

What's the preferred way of handling these sorts of patch sets?  Merged
via some kernel-janitor tree or is it expected that subsystem
maintainers pick up the individual patches?

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
