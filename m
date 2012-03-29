Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab2C2TNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:13:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13690 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2C2TNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:13:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 29 Mar 2012 12:13:11 -0700
From: Stephen Warren <swarren@nvidia.com>
To: "Stephen Rothwell (sfr@canb.auug.org.au)" <sfr@canb.auug.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>
Date: Thu, 29 Mar 2012 12:13:10 -0700
Subject: New Tegra branch for linux-next
Thread-Topic: New Tegra branch for linux-next
Thread-Index: Ac0N36AU4Kiazd7RQRyOP09UggniNg==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17E43DC742@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

Could you replace the existing Tegra branch in linux-next:

git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git for-next

with the following:

git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git for-next

(it currently contains v3.3-rc6 until the merge window is over)

... since I've taken over Tegra git maintainership.

Thanks!

-- 
nvpublic

