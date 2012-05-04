Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab2EDS4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:56:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2EDS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:56:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 00/06] serial8250: DLL/DLM rework, Emma Mobile UART driver
Date: Fri, 4 May 2012 16:28:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-serial@vger.kernel.org, horms@verge.net.au, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        dan.j.williams@intel.com, alan@linux.intel.com
References: <20120502124642.30480.41373.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041628.20024.arnd@arndb.de>
X-Provags-ID: V02:K0:+QYBETY/0EnyY5Pu7qd7QqKNp3D5hCE+KelI6CSqZmc
 e6j5/KE/As4M+LaxZZS0qEcsOm4XZ+hAN4XEWnbanz6AWXMV7a
 SK3/UGH85pN7ZQMfwUVvoQpunRK6wC+vj+7ZBrnNa0eD34HUvd
 1Kmr1JjnWjqE4KIad/d8Y47bhUlML0w1fgIaGM6RfXC0x7HPQb
 U9lKoXfLykNCmks85OvbBI5KZYdz6wtB3mIOZMXhsiy9Ppmo4B
 U7rOHrlb/ycp8bvs2SADJ+NQT+2aMAvrMK47A4NvJOFPhmSTvy
 oPYpZ8305pboj9BI2os2iPwxramhbK4LFcWumg/qxaA5mCSeX2
 GXxtn0tuBBHLah/04fGM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012, Magnus Damm wrote:
> Note that there is no DT support included at this point,
> but it boils down to a 10 line change. The boot loader on
> my board does not do DT so I'd like to use kexec for DT
> development (as usual), but to use kexec I first need to
> get a non-DT kernel working. Which is basically this. =)

As a follow-up on this, based on my comments to your emma platform
code, I think it would be easy enough to just use the appended
dtb support that we have, which allows you to boot a DT-enabled
kernel with a legacy boot loader.

	Arnd

