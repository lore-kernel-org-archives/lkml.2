Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0FNO0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:26:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33751 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab0FNOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:25:59 -0400
Date: Mon, 14 Jun 2010 15:25:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: video: DMI workaround broken Acer 5710 BIOS
	enabling display brightness
Message-ID: <20100614142554.GA22158@srcf.ucam.org>
References: <1276499864-7609-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276499864-7609-1-git-send-email-ozan@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 10:17:44AM +0300, Ozan Çağlayan wrote:
> Acer Aspire 5710 suffers from a similar ACPI problem reported at:
>  http://bugzilla.kernel.org/show_bug.cgi?id=13121

Bleah. Is this really necessary? If we set maximum brightness and then 
read back something other than maximum brightness, then that gives us 
the offset.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
