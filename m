Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2GXRXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:23:12 -0400
Received: from fep12.mx.upcmail.net ([62.179.121.32]:52208 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2GXRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:23:10 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <500ED9EC.5040309@odi.ch>
Date: Tue, 24 Jul 2012 19:22:52 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org
Subject: Re: drm/nouveau: crash regression in 3.5
References: <500D916A.60703@odi.ch> <20120724170002.GA3129@joi.lan>
In-Reply-To: <20120724170002.GA3129@joi.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.07.2012 19:00, Marcin Slusarz wrote:
> Please post the crash log.

Sorry, I was not precise: it boots until drm performs modesetting (so it 
seems). The screen goes black and the machine is dead. So there is 
nothing I could post here, unfortunately.

This is a video of 3.5 booting:
http://www.odi.ch/VIDEO0010.3gp

Don't worry about the external monitor: same behaviour with the built-in 
panel.

Thanks,

Ortwin
