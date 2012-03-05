Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2CES6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:58:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52043 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab2CES6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:58:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel.vetter@ffwll.ch designates 10.52.22.207 as permitted sender) smtp.mail=daniel.vetter@ffwll.ch; dkim=pass header.i=daniel.vetter@ffwll.ch
MIME-Version: 1.0
X-Originating-IP: [134.134.139.74]
In-Reply-To: <CAF6AEGtynLeNds9DFjr6G08UMWMBQn8tn10UgFTNz9P7SwQuUQ@mail.gmail.com>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
	<1330616161-1937-3-git-send-email-daniel.vetter@ffwll.ch>
	<CAF6AEGtynLeNds9DFjr6G08UMWMBQn8tn10UgFTNz9P7SwQuUQ@mail.gmail.com>
Date: Mon, 5 Mar 2012 19:57:59 +0100
Message-ID: <CAKMK7uHnNMytknBO2y=ioPXJ9tZpy99ntGP=iPVzyjvXmTmj9g@mail.gmail.com>
Subject: Re: [PATCH 2/3] dma-buf: add support for kernel cpu access
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 23:24, Rob Clark <robdclark@gmail.com> wrote:
> Perhaps we should check somewhere for required dmabuf ops fxns (like
> kmap_atomic here), rather than just calling unconditionally what might
> be a null ptr.  At least put it in the WARN_ON(), but it might be
> nicer to catch a missing required fxns at export time, rather than
> waiting for an importer to try and call it.  Less likely that way, for
> newly added required functions go unnoticed.
>
> (same comment applies below for the non-atomic variant.. and possibly
> some other existing dmabuf ops)

Agreed, I'll rework the patch to do that when rebasing onto Sumit's latest tree.
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
