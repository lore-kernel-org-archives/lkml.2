Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2FFI45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:56:57 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:34883 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713Ab2FFI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:56:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [bisected commit 0fc9d10] NFS-server corruption with 3.4
Date: Wed, 6 Jun 2012 10:55:26 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Hugh Dickins <hughd@google.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Hans de Bruin <jmdebruin@xmsnet.nl>,
        Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>
References: <201206051116.17711.linux@rainbow-software.org> <4FCE2256.7010804@openvz.org> <4FCE2CCE.9000900@openvz.org>
In-Reply-To: <4FCE2CCE.9000900@openvz.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206061055.27049.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2012, Konstantin Khlebnikov wrote:
> Proper fix in attachment.

Applying this patch to clean 3.4 fixes the problem.

-- 
Ondrej Zary
