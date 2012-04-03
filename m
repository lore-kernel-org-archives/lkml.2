Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2DCOHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:07:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2DCOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:07:29 -0400
Date: Tue, 3 Apr 2012 09:07:24 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Akio Idehara <zbe64533@gmail.com>
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] toshiba_acpi: Add support for transflective LCD
Message-ID: <20120403140724.GB18485@thinkpad-t410>
Mail-Followup-To: Akio Idehara <zbe64533@gmail.com>, mjg59@srcf.ucam.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1333120590-4868-1-git-send-email-zbe64533@gmail.com>
 <20120402193952.GD24020@thinkpad-t410>
 <4F7B01C8.9050109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7B01C8.9050109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 10:57:28PM +0900, Akio Idehara wrote:
> Hi, Seth.
> 
> Thank you for reviewing my code again and again.
> All your comments make sense.
> I'll try to make the v3 patch.

Great!

I realized I also forgot to mention, it would be better to come up with
a more descriptive name than tmp for the local variable you added to
get_lcd() as well.

Thanks,
Seth

