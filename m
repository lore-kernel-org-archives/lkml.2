Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2A3Qts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:49:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2A3Qtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:49:46 -0500
Message-ID: <4F26D815.3040105@mvista.com>
Date: Mon, 30 Jan 2012 20:49:09 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Witten <mfwitten@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/3] mips: use the the PCI controller's io_map_base
References: <cover.1327877053.git.mst@redhat.com> <dd3dab360f11d4f8829854891d04bf838bc50e5e.1327877053.git.mst@redhat.com>
In-Reply-To: <dd3dab360f11d4f8829854891d04bf838bc50e5e.1327877053.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/30/2012 03:18 PM, Michael S. Tsirkin wrote:

> commit eab90291d35438bcebf7c3dc85be66d0f24e3002

    Please add that commit's summary in parens.

> failed to take into account the PCI controller's
> io_map_base for mapping IO BARs.
> This also caused a new warning on mips.

> Fix this, without re-introducing code duplication,
> by setting NO_GENERIC_PCI_IOPORT_MAP
> and supplying a mips-specific __pci_ioport_map.

> Reported-by: Kevin Cernekee <cernekee@gmail.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

WBR, Sergei
