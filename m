Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1EUKxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:53:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58820 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1EUKxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ioLhy5PLPbg3wEioLG630j2QAa/8jfiYGWhzl07C/WEKx8Ea0+t8S9iKcXCsGvMCZn
         LHRtjabiweS0CRhj4MwBtIxGVELaluX18aYm8B1bCG3j8aue+YCIcm3oYuDtUvE2TxPd
         sZr/I//Z6jemPWfZMr7oERajpu1kuDlFVzmaY=
Subject: Re: [PATCHv4 0/4] Initial support for TPS65912 PMIC
From: Liam Girdwood <lrg@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Margarita Olaya <magi@slimlogic.co.uk>
In-Reply-To: <BANLkTim56oPzQ_knGc6ezg+9_CY2kqshqQ@mail.gmail.com>
References: <BANLkTi=5MY7Lr4KU4vtOFSQiOedKGXxZLw@mail.gmail.com>
	 <BANLkTim56oPzQ_knGc6ezg+9_CY2kqshqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 11:53:17 +0100
Message-ID: <1305975198.3317.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 13:51 -0500, Margarita Olaya wrote:
> Hi,
> 
> On Mon, May 16, 2011 at 6:02 PM, Margarita Olaya <magi@slimlogic.co.uk> wrote:
> > Hi,
> >
> > This is the initial version of the TPS65912 PMIC, a power management IC
> > for multimedia products.
> >
> > The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> > voltage to main processor and other components. The chip includes a
> > GPIO module.
> >
> > Changes from V3:
> > - split core driver into tps65912-spi and tps65912-i2c
> > - create new function in regulator with common code in set/get mode
> >
> 
> Do you have any comments on this version of the driver? Please let me know them.
> 

Grant, Samuel,  If the mfd/gpio sections are fine with you I can take
via regulator. I plan to do the regulator pull request on Monday or
Tuesday.

Thanks !

Liam

