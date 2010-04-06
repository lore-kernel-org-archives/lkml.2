Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0DFMqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:46:12 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:40057 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0DFMqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:46:02 -0400
Message-ID: <4BBB2CC3.5010300@csr.com>
Date: Tue, 06 Apr 2010 13:44:51 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] drivers/usb/wusbcore/wusbhc.h: Remove unused dev_info
 from struct wusb_port
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org> <8ec25276e62c8b9669ad8e46a6f5f9cbb0f507c3.1270493677.git.joe@perches.com>
In-Reply-To: <8ec25276e62c8b9669ad8e46a6f5f9cbb0f507c3.1270493677.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2010 12:44:51.0613 (UTC) FILETIME=[F334ACD0:01CAD586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> There is a macro called dev_info that prints struct device specific
> information.  Having variables with the same name can be confusing and
> prevents conversion of the macro to a function.
> 
> Rename the existing dev_info variables to something else in preparation
> to converting the dev_info macro to a function.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This commit message isn't strictly correct but otherwise,

Acked-by: David Vrabel <david.vrabel@csr.com>

Not sure what this field was ever for...

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
