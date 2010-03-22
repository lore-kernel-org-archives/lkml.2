Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0CVSNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:13:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35032 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab0CVSNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:13:30 -0400
Date: Mon, 22 Mar 2010 11:13:27 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Dan Carpenter <error27@gmail.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] power_meter: acpi_device_class "power_meter_resource"
	too long
Message-ID: <20100322181327.GG22820@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20100319114920.GP5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319114920.GP5331@bicker>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 02:49:20PM +0300, Dan Carpenter wrote:
> acpi_device_class can only be 19 characters and a NULL terminator.
> 
> The current code has a buffer overflow in acpi_power_meter_add():
>        strcpy(acpi_device_class(device), ACPI_POWER_METER_CLASS);
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Feel free to change the name to anything you like.

How hard would it be to increase the size of that buffer?

(Or, is there a need to have "_resource" in that string at all?)

--D
