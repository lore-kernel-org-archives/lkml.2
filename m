Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab0E0Dpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:45:46 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:38310 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab0E0Dpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=JffMRqlVpQH9lLRNlScGEyXV0RArXEpm9WT33a29q06rvU+cImBIvZWkUSo0EYAbNb
         KxQdB6QlfX1nwYNOydhfqayqCsyTKzJC3ctUozOgs0RjdT+bJr3PPwQXdXRvgb4Mg6zt
         CONOLNBJjGSLxlZFr43rClDmzZGvMzWg3e/X8=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1005211410170.14789@sister.anvils>
References: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com> 
	<AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com> 
	<AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com> 
	<alpine.LSU.2.00.1005211410170.14789@sister.anvils>
From: dave b <db.pub.mail@gmail.com>
Date: Thu, 27 May 2010 13:45:23 +1000
Message-ID: <AANLkTil8sEzrsC9If5HdU8S5R-sK84_fUt_BXUDcAu0J@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was just a simple test case with dd. That test case might be
invalid - but it is trying to trigger out of memory - doing this any
other way still causes the problem. I note that playing with some bios
settings I was actually able to trigger what appeared to be graphics
corruption issues when I launched kde applications ... nothing shows
up in dmesg so this might just be a conflict between xorg and the
kernel with those bios settings...

Anyway, This is no longer a 'problem' for me since I disabled
overcommit and altered the values for dirty_ratio and
dirty_background_ratio - and I cannot trigger it.
