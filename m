Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1KJTbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:31:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1KJTbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111110091816.GA2247@nomi.cz>
References: <20111029171554.GA16596@nomi.cz>
	<20111031160342.GB2225@redhat.com>
	<20111109155411.GA1669@nomi.cz>
	<20111109165158.GA2254@redhat.com>
	<20111110091816.GA2247@nomi.cz>
Date: Thu, 10 Nov 2011 11:31:45 -0800
X-Google-Sender-Auth: AULO58Thih93Bm4r1GAvWdYyFhU
Message-ID: <CAJ-VmonOg+1G4xHjApkDwNo2GF-7pVoE7o5Vefr4Eaq5UJxM9Q@mail.gmail.com>
Subject: Re: iwlagn: memory corruption with WPA enterprise
From: Adrian Chadd <adrian@freebsd.org>
To: =?ISO-8859-2?B?VG9t4bkgSmFub3W5ZWs=?= <tomi@nomi.cz>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. are you sure it's a software use-after-free?
What about "NIC DMA'ing stuff into completely incorrect space" after free? :-)
(Or a firmware/NIC bug where it scribbles to random memory at times..)


Adrian
