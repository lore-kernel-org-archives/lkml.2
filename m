Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0JEKCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:02:40 -0400
Received: from smtp.nokia.com ([192.100.122.230]:53617 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0JEKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:02:39 -0400
Subject: Re: [PATCH] video/omap: remove mux.h include
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Nicolas Kaiser <nikai@nikai.net>
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101004203842.088b0cb2@absol.kitzblitz>
References: <20101004174344.21577085@absol.kitzblitz>
	 <20101004175429.GW3117@atomide.com>
	 <20101004203842.088b0cb2@absol.kitzblitz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 13:02:22 +0300
Message-ID: <1286272942.2358.29.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Oct 2010 10:02:28.0192 (UTC) FILETIME=[6ADB1E00:01CB6474]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 20:38 +0200, ext Nicolas Kaiser wrote:
> Including mux.h should no longer be needed for omap2/3/4 SoCs
> outside arch/arm/mach-omap2 files.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Thanks, applied to my tree.

 Tomi


