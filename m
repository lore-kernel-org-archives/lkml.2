Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2KLOSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:18:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2KLOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:18:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC PATCH 00/11] arch_gettimeoffset and ARM timer rework
Date: Mon, 12 Nov 2012 14:17:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121417.58380.arnd@arndb.de>
X-Provags-ID: V02:K0:no5SZ9t9oIvKWFIdmeno83zcvHctC/X+NEPgCoaIOT4
 u9XH/87172RICtioNhEvwJ1EoIgX/7mKC2moAKD8biGaw1qRIV
 EleGGG+4vnEj63CBOxvO72DMfSYOn/lm6lAY/ABBlbZwV3/0Ja
 7ZUpZGs9q8zffCma4yi+HfgOKm/ylYpY/QZDvj5+IIs/3fO0xW
 XpYZxvjSWi2nNuNjOErs+YCjg/z4yxdxKaEcN9O99oZ8SAXSBt
 QnG97I2+5R2Oc/FGxz1iutwKPgTPqj/C0F01d7l4TLIm/0npXf
 xyZ1d++CUIRcTmAMFuGhklG3rRJqb+VqsQpTPFBLaen/GUwbXo
 QLXNsD6dx2VEWqCUocgo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012, Stephen Warren wrote:
> It would probably be easiest to merge this whole series through the
> arm-soc tree. Anything else would require some co-ordination.

Fine with me. The patches all look good to me, so let's give people a
little more time to weigh in with Acks and possible objections.

In particular, I hope Russell can comment if he has an opionion on these.

	Arnd
