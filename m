Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1FMVNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:13:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45204 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1FMVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=jKlyHkZiwaSvB0XFzJnB+AwZc+MN7MsoKx2Wey0/6wY9CgNcnNAC76PpuBccxD9Jml
         lq+YmmPLrzTpnfwI9Z+bjksysYG+xx3rhRGzPw8WTGuJQHjmWE4ohC5nviGbBUHdhmQX
         +gUYC4DbbRTZ0/HlMUrB8r/g7bw5mNYPSPlrQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=i-NDzgsT2mCqL0p+r5ok_-=znGdWDYV-oi9z-8e9LvQ@mail.gmail.com>
References: <BANLkTi=i-NDzgsT2mCqL0p+r5ok_-=znGdWDYV-oi9z-8e9LvQ@mail.gmail.com>
From: =?UTF-8?Q?Rui_Tiago_Ca=C3=A7=C3=A3o_Matos?= <tiagomatos@gmail.com>
Date: Mon, 13 Jun 2011 22:12:39 +0100
Message-ID: <BANLkTi=snWs0srAKON71yysvFcN_HHO05Q@mail.gmail.com>
Subject: Re: [3.0.0-rc2+][nouveau] BUG: unable to handle kernel NULL pointer
 dereference nv50_vm_map_sg+0x37/0xb0
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks suspiciously like
https://bugzilla.redhat.com/show_bug.cgi?id=699551 which has been
happening since at least 2.6.38.

Rui
