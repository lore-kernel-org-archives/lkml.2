Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0FNQpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:45:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20671 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab0FNQpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:45:20 -0400
Date: Mon, 14 Jun 2010 09:44:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] Adding support for BMP085 pressure sensor.
Message-Id: <20100614094448.cd1a76b9.randy.dunlap@oracle.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B34A6178@dbde02.ent.ti.com>
References: <0680EC522D0CC943BC586913CF3768C003B34A6178@dbde02.ent.ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C165C9C.02AD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 19:49:00 +0530 Datta, Shubhrajyoti wrote:

> 
> Adding support for BMP085 pressure sensor.
> The interface of the device is I2C.
> The driver is based on a version initially written by Christoph
> Mair.
> 
> 
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti@ti.com>
> ---
>  drivers/misc/bmp085.c |  342 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 342 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/bmp085.c


No Kconfig and Makefile changes?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
