Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1AGLQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:16:52 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56151 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1AGLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:16:51 -0500
Date: Fri, 7 Jan 2011 12:16:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: "James C. Georgas" <james.georgas@yahoo.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [Bulk] Re: can't resume from ACPI S3 with TICK_ONESHOT
Message-ID: <20110107111658.GE16507@aftab>
References: <1294191939.3889.49.camel@Tachyon>
 <20110105120959.GB4927@kryptos.osrc.amd.com>
 <1294242385.3650.38.camel@Tachyon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294242385.3650.38.camel@Tachyon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 10:46:25AM -0500, James C. Georgas wrote:
> Let me know if you need more.

Yeah, what does

xxd /sys/firmware/acpi/tables/HPET

say?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
