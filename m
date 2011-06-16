Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1FPIui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:50:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab1FPIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:50:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
Date: Thu, 16 Jun 2011 10:50:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1308163895-5963-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161050.27716.arnd@arndb.de>
X-Provags-ID: V02:K0:hAfc2SfFG8+RY4usN9TaMbxck3+vZezjZpJB28UT0o2
 OlRdUn5W152DUk6MZHpK5Zjd8w6lQqrbiKNatFaNoGGVZ+hij0
 vASUMQa7JnqFpYjL8np2CRiLoRoxLb+Q5p5aw/dausqk7NviAu
 XwoJ1HVIFBM0d5pIQtB2U8aPrG2mI0Vf48eEKZ6YVmps3H9o+t
 GsgA9pGaVOavmfN3dxceg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 June 2011, Vasiliy Kulikov wrote:
> 
> This patch series adds support of procfs mount options and adds
> mount options to restrict /proc/<pid>/ directories to owners and
> /proc/<pid>/net/* to root.  Additional group may be defined via
> gid=, and this group will be privileged to study others /proc/<pid>/
> and networking information.
> 
> Similar features are implemented for old kernels in -ow patches (for
> Linux 2.2 and 2.4) and for Linux 2.6 in -grsecurity, but both of them
> are implemented as configure options, not cofigurable in runtime, with
> changes of gid of /proc/<pid>/, and without backward-compatible
> /proc/<pid>/net/* handling.

The patches all look good to me implementation-wise.

I have no opinion on whether it's a good idea to include the feature or not.

	Arnd
