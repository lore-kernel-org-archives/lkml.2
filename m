Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2HVGFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:05:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48301 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab2HVGE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:04:56 -0400
Date: Tue, 21 Aug 2012 23:04:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Eric Andersson <eric.andersson@unixphere.com>,
        Andrew Jones <drjones@redhat.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 3/8] DA9058 ONKEY driver
Message-ID: <20120822060450.GG20624@core.coreip.homeip.net>
References: <201208151518.q7FFINn3011629@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151518.q7FFINn3011629@latitude.olech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:05:22PM +0100, Anthony Olech wrote:
> This is the ONKEY component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE component driver of the DA9058 MFD.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>

This is almost exact copy of da9052_onkey, can they be merged together?

Thanks.

-- 
Dmitry
