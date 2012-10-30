Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab2J3RnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:43:09 -0400
Received: from mail.agmk.net ([91.192.224.71]:43695 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822Ab2J3RnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:43:07 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Don Morris <don.morris@hp.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [3.6.2] oops @ opteron server: mgag200 Fatal error during GPU init
Date: Tue, 30 Oct 2012 18:43:02 +0100
Message-ID: <1528950.lfMO1YRB8m@localhost>
User-Agent: KMail/4.9.1 (Linux/3.7.0-rc2-00191-g2ab3f29; KDE/4.9.2; x86_64; ; )
In-Reply-To: <508165C3.8080702@hp.com>
References: <1993905.xE9oHSL7vg@localhost> <508165C3.8080702@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 of October 2012 07:37:55 Don Morris wrote:
> [drm:mga_vram_init] ERROR can't reserve VRAM

Hi again, small update.

i've figured out that loading uvesafb before mgag200 is causing this vram-reserve-error.

BR,
Paweł.

