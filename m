Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2BDQm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:42:27 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48621 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2BDQmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:42:25 -0500
MIME-Version: 1.0
Message-ID: <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
Date: Sat, 4 Feb 2012 08:42:15 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] xen/tmem: cleanup
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
In-Reply-To: <4F2C06A00200007800071071@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F2D5FEB.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@suse.com]
> Subject: [PATCH] xen/tmem: cleanup
> 
> Use 'bool' for boolean variables. Do proper section placement.
> Eliminate an unnecessary export.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> -int tmem_enabled __read_mostly;
> -EXPORT_SYMBOL(tmem_enabled);
> +bool __read_mostly tmem_enabled = false;

tmem_enabled is used in xen/drivers/xen-selfballoon.c
