Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab2BIWUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:20:20 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42952 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758235Ab2BIWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:20:18 -0500
X-Sasl-enc: k5diZfaZkv20xx+lNbUAht/uv9HsAqnd62As9KGS4YRY 1328826016
References: <20120209.163009.1594369939327153054.davem@davemloft.net> <20120210084048.2f019c32707151631a57458a@canb.auug.org.au>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120210084048.2f019c32707151631a57458a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 8250 move broke the build on sparc
From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 09 Feb 2012 13:54:35 -0800
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>
CC: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Message-ID: <030f7edf-f570-44a4-9cae-335641b40fc2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi Dave,
>
>On Thu, 09 Feb 2012 16:30:09 -0500 (EST) David Miller
><davem@davemloft.net> wrote:
>>
>> Commit 9bef3d4197379a995fa80f81950bbbf8d32e9e8b ("serial: group all
>> the 8250 related code together") broke the build on sparc.
>> 
>> You really can't move 8250.c around without adjusting the "" includes
>> such as the one for "suncore.h".
>> 
>> Simply changing "suncore.h" to "../suncore.h" fixes things, but
>that's
>> pretty ugly if you ask me.
>
>There is a commit that does just that in Greg's tty tree (in
>linux-next).


This fix went to Linus a few hours ago.
