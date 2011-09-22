Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115Ab1IVP2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:28:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1IVP2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:28:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
Date: Thu, 22 Sep 2011 17:28:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF04B3279D4F@HQMAIL01.nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF04B73215C9@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B73215C9@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109221728.09063.arnd@arndb.de>
X-Provags-ID: V02:K0:y8yxH2+Q+IdQk9YAucltxaNKR7Lq4uytwVIHt8wpWln
 ovGbxO1R00F+gG/Wx/csQruGdUBFDzfu449IJrVTGjpgsIQB5T
 vaDgo3zMSsZPFP7yrbzR+EbBYleRu4N6OasmcWwVhT2g3lBYGW
 8NvHpQt7CxPd4sObsxMDAyKhZNlQwN5P9pSzdHYJAxNvrOtgWU
 3iKottFJ23plMtabrWVOHAZ6gFNBuGtVPfmygjBMdR+3fjvbZ6
 Zd1rBrg8h2+uF2qg5UEPKVVrrKelP6M0+UT+k6zCR04S7XOn2m
 GDi+fcEI7s1E2lEwZ9Sj7rNWh3fP4qVE6QGc5sPzSSlF4kPDcX
 7BYcPTeGizljSC3LOtj4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011, Stephen Warren wrote:
> Stephen Warren wrote at Tuesday, August 30, 2011 10:25 AM:
> > Ben, Arnd,
> > 
> > Could you please ack/nack the patch at the start of this thread for Colin;
> > see below.
> 
> Ben, can you please comment on the acceptability of this patch?
> 
> Or Arnd, did Mark's most recent explanation of the situation provide enough
> context for you to ack/nak it?
> 

After looking through the discussion again, my feeling is that it's ok
and I think that Mark's word should count more than mine anyway on this
issue.

If you think it helps, you can add my Acked-by, but this is really
something for Ben to decide. Just resubmit the patch to Ben with an
an updated changelog that summarises the discussion, in case
Ben got bored already and put this mail thread into the ignore
folder...

	Arnd
