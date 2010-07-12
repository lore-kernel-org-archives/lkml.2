Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0GLTuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:50:03 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:60282 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab0GLTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:49:59 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 1A32B2D6595
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH 0/7] De-couple sysfs memory directories from memory sections
To: Nathan Fontenot <nfont@austin.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 12 Jul 2010 21:30:56 +0200
References: <f5t7d-2ZJ-23@gated-at.bofh.it>
User-Agent: KNode/4.3.5
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Message-Id: <20100712194958.1A32B2D6595@mail-in-10.arcor-online.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot <nfont@austin.ibm.com> wrote:

> The file 'split' allows for splitting the
> directory in two, with each new directory covering half as many
> memory sections as the previous directory.

Just some random thoughts:

1) Why is it needed/helpful?
2) If it is needed, why not take an int to split after n entries?
