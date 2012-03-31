Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab2CaAYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:24:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36291 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2CaAYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:24:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UNHufTggg0ka-+q7ri_X6ENx4nO5DfMCAxxrKLrERPWg@mail.gmail.com>
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
 <20120206160727.GA21048@tuxdriver.com> <20120207041958.GA32377@bombadil.infradead.org>
 <CAB=NE6VS79S4R6wQddQCqPfoYPyRbPzSdAYN2Mxfi-4G_sfCvg@mail.gmail.com>
 <CAB=NE6Wv3PEJj5zKfK2o869ntxuU3V+Nv2dgKX1eDtk3zQ04dA@mail.gmail.com>
 <CAB=NE6URWAgUgF+6bOsRBeeXnQ4VjYf1tWuUkkvMviCLOCxeqA@mail.gmail.com> <CAB=NE6UNHufTggg0ka-+q7ri_X6ENx4nO5DfMCAxxrKLrERPWg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 30 Mar 2012 17:23:46 -0700
X-Google-Sender-Auth: r6z_bzaqFAPwx6-SZ6P-PjNt-BU
Message-ID: <CAB=NE6U_Sq88ro7onChn8U4tkkqt7Z9YN9wMyZjx+78j+M=_uA@mail.gmail.com>
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, hauke@hauke-m.de,
        kernel-team@lists.ubuntu.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy, so I just noticed that on all Ubuntu PPA (and generic) kernels
you guys have a broken symlink >= 2.6.33.

/lib/modules/2.6.33-02063305-generic/build/include/asm

points to asm-x86 and that is no longer present after 2.6.33 so any
module requiring those header files will break now on Ubuntu. I just
spotted this as some file from asm is now included in the modules were
are building. I guess not many external kernel modules include asm dir
otherwise you guys would have noticed this a long time ago.

  Luis
