Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0L3LfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 06:35:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41601 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326Ab0L3LfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 06:35:05 -0500
Date: Thu, 30 Dec 2010 11:35:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rabin Vincent <rabin@rab.in>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Jean Delvare <khali@linux-fr.org>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Vishwanath BS <vishwanath.bs@ti.com>, Partha Basak <p-basak2@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org
Subject: Re: i2c runtime suspend and system wide suspend
Message-ID: <20101230113502.GA8537@opensource.wolfsonmicro.com>
References: <4D1C0CFE.5010008@codeaurora.org> <AANLkTinqqgNwgFCMVL-2T83zKnNLGLF007atJ4-EDEW5@mail.gmail.com> <201012301149.30888.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012301149.30888.rjw@sisk.pl>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 11:49:30AM +0100, Rafael J. Wysocki wrote:
> On Thursday, December 30, 2010, Rabin Vincent wrote:

> > https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029658.html

> I'm not sure what happened to the last patch.  Is there a new version?
> If so, is it going to be pushed through the i2c tree, or should I take it?

Jean appears to be on holiday for the Christmas vacation.  I do have a
new version which I'll post later today.  Since it depends on the patch
protoyping the generic API calls which the SPI patch also depends on
it'd probably be best to merge via your tree.
