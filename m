Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2ELMH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 08:07:59 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2908 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755217Ab2ELMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 08:07:57 -0400
X-Greylist: delayed 2148 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 May 2012 08:07:56 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q4CBW2s1021561
Subject: Re: [RFC 1/1] driver core: Add dev_*_ratelimited() family
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Sat, 12 May 2012 13:32:03 +0200
In-Reply-To: <20120512.135227.1196366807162247040.hdoyu@nvidia.com>
References: <20120512.135227.1196366807162247040.hdoyu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336822324.14918.9.camel@thorin>
Mime-Version: 1.0
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sam, 2012-05-12 at 12:52 +0200, Hiroshi Doyu wrote:
[...]
> An unclosed "if" statement in the MACRO seems a bit risky, but I don't
> have any better/simple solution for this, ATM. Is there any alternative?

No, the "do { ... } while (0)" is actually the only one and widely used
- not only in the Linux kernel.

[....]

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

