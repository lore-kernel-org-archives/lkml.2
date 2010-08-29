Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0H2SuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:50:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50617 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0H2SuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U7ojXaus/YCyLPdgTgegxWJifmk3siOwYJxGXkQilXSG8S5i2QGsicH1Avt6fytknK
         ERYdKPeUk+5Fzb7Ms/QtRU6hJ1qjF5u7kSwzEVjXlmGB4t4woYBHV41VQmC1fGrepRLZ
         xeZ0O+dXV0BhF/qix74+JcJHDfpChGpX0RReI=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-9-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-9-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:47:55 +0300
X-Google-Sender-Auth: BwXYMvgpmzw50QDudYpLMWWEICU
Message-ID: <AANLkTimwQ_-c3BswnSArgLjUj0K96aSSVSSzF+AOa91_@mail.gmail.com>
Subject: Re: [PATCH 08/11] x86-32: Remove math_emulate stub
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> check_fpu() in bugs.c halts boot if no FPU is found and math emulation
> isn't enabled.  Therefore this stub will never be used.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
