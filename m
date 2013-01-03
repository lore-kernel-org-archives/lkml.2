Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3ACWnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:43:55 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:52302 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab3ACWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:43:53 -0500
Subject: Re: [PATCH] platform: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130103224020.GB4571@kroah.com>
Date: Fri, 4 Jan 2013 00:43:46 +0200
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Content-Transfer-Encoding: 7bit
Message-Id: <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com> <20130103224020.GB4571@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Jan 4, 2013, at 12:40 AM, Greg Kroah-Hartman wrote:

> On Fri, Jan 04, 2013 at 12:31:10AM +0200, Pantelis Antoniou wrote:
>> Platform device removal uncovered a number of problems with
>> the way resources are handled in the core platform code.
>> 
>> Resources now form child/parent linkages and this requires
>> proper linking of the resources. On top of that the OF core
>> directly creates it's own platform devices. Simplify things
>> by providing helper functions that manage the linking properly.
>> 
>> Two functions are provided:
>> 
>> platform_device_link_resources(), which links all the
>> linkable resources (if not already linked).
>> 
>> and platform_device_unlink_resources(), which unlinks all the
>> resources.
> 
> Who would call these functions, and why?
> 
> And why have we never seen problems with removing platform devices
> previously?
> 

Have you tried removing devices that were created via DT and 
not using platform data?

> thanks,
> 
> greg k-h

Regards

-- Pantelis

