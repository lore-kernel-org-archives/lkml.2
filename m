Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab1D0NxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:53:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293Ab1D0NxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:53:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Weil <oren.jer.weil@intel.com>
Subject: Re: [PATCH 7/8] staging/mei: AMT Watchdog
Date: Wed, 27 Apr 2011 15:53:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com> <1303900057-21694-8-git-send-email-oren.jer.weil@intel.com>
In-Reply-To: <1303900057-21694-8-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271553.01464.arnd@arndb.de>
X-Provags-ID: V02:K0:9B8+mIvbxTRHb4zJj20ygVNtgByDp2Nv1Js6Ghz7ECZ
 NO0hsDv2kDmGFspvkb8V3TtIqME6ieFiY96hwon0NxGrpp1TFl
 8oBWJQToKQCj7nOZtqNelJNjnms4qeXC3VIL7kGF+Q/fdmB28O
 pTx5DP60VieE/Y+C4c/aT2/r1gX9AtHPVhsqSKFYejpeFkC1MD
 G9P06XNRyRrDSu0hhapRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Oren Weil wrote:
> 
> code that open connection and invoke
> heartbeats to the AMT Watchdog client/feature, if exists
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
> Signed-off-by: Oren Weil <oren.jer.weil@intel.com>

I still think this should be a regular watchdog driver using
the drivers/watchdog user interface.

	Arnd
