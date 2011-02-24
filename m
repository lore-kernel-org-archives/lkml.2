Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1BXOEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:04:37 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42635 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1BXOEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:04:35 -0500
Date: Thu, 24 Feb 2011 15:05:41 +0100
From: Borislav Petkov <bp@amd64.org>
To: David Sterba <dsterba@suse.cz>
Cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] i7core_edac: fix misuse of logical operation
 in place of bitop
Message-ID: <20110224140541.GB11239@aftab>
References: <20110221144146.GE5766@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221144146.GE5766@ds.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 09:41:46AM -0500, David Sterba wrote:
> 
> CC: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> 
> Hi Mauro, this fix has not been applied yet, can you please pick it up?

Yeah, this looks wrong. Is this tested? Is it something you hit when
running the driver or you've caught it with some tool/by code staring?

If it is a real problem for you, I could make an exception and send it
to Linus next week if Mauro doesn't do it before that.

Ok?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
