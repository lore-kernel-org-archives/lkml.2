Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0H2Se3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:34:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58745 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0H2Se2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bkKVxf7OHlxvLndbNGcxkRjX+vUj1ui9mNZiaIy8asKD4PntcThLeEYAFPCMsRoaPf
         oa925M6dkntOjsJx84dYyHamnMKnmlv/9uK2tFwFtXVFeIaSUma8nA9AQy/Vzk3Wh1cQ
         D3sgbKuaKuJCZ/ZakzsNvgpHJDyndJp8aXBSw=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-5-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-5-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:33:53 +0300
X-Google-Sender-Auth: L1PZKgW9Ud7Ui-u70rHpp6abxBE
Message-ID: <AANLkTik=VTAq__-w8E8aO8L4F8sAVxBza5-FNXt9yrrj@mail.gmail.com>
Subject: Re: [PATCH 04/11] x86: Merge __save_init_fpu()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> __save_init_fpu() is identical for 32-bit and 64-bit.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
