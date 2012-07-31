Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2GaHGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:06:15 -0400
Received: from fep13.mx.upcmail.net ([62.179.121.33]:33215 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2GaHGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:06:13 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
References: <500D916A.60703@odi.ch> <20120724170002.GA3129@joi.lan> <500ED9EC.5040309@odi.ch> <20120724205746.GA8707@joi.lan> <500FB279.1020904@odi.ch> <20120725184205.GA3119@joi.lan> <50113E76.9090706@odi.ch> <20120729201532.GA3566@joi.lan> <50166D15.7090305@odi.ch> <20120730171629.GA3271@joi.lan>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120730171629.GA3271@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: drm/nouveau: crash regression in 3.5
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Date: Tue, 31 Jul 2012 09:06:09 +0200
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Message-ID: <38d47fda-297e-4f8d-a275-ac61b117fc46@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, as far as I can tell. I didn't do anything different this time. The date on the kernel file looks ok. Just did a fresh make && make install again, and got the same behaviour. When is that number after the hash sign upped?

Marcin Slusarz <marcin.slusarz@gmail.com> wrote:


>Are you sure you boot the correct kernel? I'm asking because your panic
>says its
>version is "3.5.0 #3" - exactly the same as in previous crash log.
>
>Marcin

