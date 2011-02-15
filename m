Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1BOBw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:52:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7540 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1BOBwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:52:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 14 Feb 2011 17:52:22 -0800
From: Andrew Chew <AChew@nvidia.com>
To: "'Erik Gilling'" <konkers@android.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
Date: Mon, 14 Feb 2011 17:52:21 -0800
Subject: RE: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
Thread-Topic: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
Thread-Index: AcvMsqi07iIZZN0+QCiQ484BTthIqwAACdcA
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BD96CFB3@HQMAIL03.nvidia.com>
References: <1297726034-32762-1-git-send-email-achew@nvidia.com>
	<AANLkTinvpo=R1pjvykEZVXV08D+uXLJa=R8CDcMFWWpT@mail.gmail.com>
	<643E69AA4436674C8F39DCC2C05F763816BD96CFB1@HQMAIL03.nvidia.com>
	<AANLkTin+uxnM-u7N-+aXUzGVm7m2eXZKrenDbRPq1V-W@mail.gmail.com>
	<643E69AA4436674C8F39DCC2C05F763816BD96CFB2@HQMAIL03.nvidia.com>
 <AANLkTi=aMA_OTgtw37jdDrSyMm4jmvpvFt5LpyyoG9PP@mail.gmail.com>
In-Reply-To: <AANLkTi=aMA_OTgtw37jdDrSyMm4jmvpvFt5LpyyoG9PP@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You're right about that global nvhost_syncpt pointer.  That 
> drives me nuts as well.  Nevertheless, I'm not sure I'm 
> knowledgeable enough to do the required work to do this the 
> "right" way.  As far as I know, nvhost is a guaranteed 
> singleton in practice (not in implementation), so while this 
> is ugly, it will work fine for existing projects.
> 
> If you feel uncomfortable making this change, I recommend you include
> the private header file the way the dc does.

Okay, I'll do it this way then.