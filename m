Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2GXRAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:00:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49535 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2GXRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:00:07 -0400
Date: Tue, 24 Jul 2012 19:00:02 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120724170002.GA3129@joi.lan>
References: <500D916A.60703@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500D916A.60703@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 08:01:14PM +0200, Ortwin Glück wrote:
> Hi,
> 
> My HP Elitebook 8540w now crashes on boot with 3.5. All works fine with 
> 3.4. Bisected to the following commit:
> 
> 20abd1634a6e2eedb84ca977adea56b8aa06cc3e is the first bad commit
> commit 20abd1634a6e2eedb84ca977adea56b8aa06cc3e
> Author: Ben Skeggs <bskeggs@redhat.com>
> Date:   Mon Apr 30 11:33:43 2012 -0500
> 
>      drm/nouveau: create real execution engine for software object class
> 
>      Just a cleanup more or less, and to remove the need for special 
> handling of
>      software objects.
> 
>      This removes a heap of documentation on dma/graph object formats. 
> The info
>      is very out of date with our current understanding, and is far better
>      documented in rnndb in envytools git.
> 
>      Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> 
> lspci:
> 01:00.0 VGA compatible controller: NVIDIA Corporation GT215 [Quadro FX 
> 1800M] (rev a2)
> 

Please post the crash log.

Marcin
