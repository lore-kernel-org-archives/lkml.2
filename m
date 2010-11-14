Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab0KNFVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:21:08 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64220 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0KNFVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:21:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=gCpy6tlgEllMTzmBuZ92wSNePiScLh8mO+OWLMXMnu+07Ow68N8b42rPsr03RRXOv4
         9/WisBeD7YUVOk7Gx2OEaDX/cpBfngkn/m3vjhVQV6MC6SonJPdabwq2IRrSkaRzAd1P
         v0sZ5JscX66Hk1QtgM9GOymXcEjnElRb+Opd4=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
In-Reply-To: <20101114140920.E013.A69D9226@jp.fujitsu.com>
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com> <877hgmr72o.fsf@gmail.com> <20101114140920.E013.A69D9226@jp.fujitsu.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 14 Nov 2010 00:20:57 -0500
Message-ID: <87y68wiipy.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010 14:09:29 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> Because we have an alternative solution already. please try memcgroup :)
> 
Alright, fair enough. It still seems like there are many cases where
fadvise seems more appropriate, but memcg should at least satisfy my
personal needs so I'll shut up now. Thanks!

- Ben
