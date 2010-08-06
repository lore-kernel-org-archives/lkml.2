Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935069Ab0HFUoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:44:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33839 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762044Ab0HFUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RjRnA7QaDCMO5LfTxyvUKwRWMVFnfoLycInpXZfCw75ChJ0yyVP1OsQ1V3fLo4Vlix
         H5pKb9L2JcPgCf9H4UgJaFzcPEGFEERMW2Rk6TGzlrnBm93VX1GjtmlWhqIYHVPy6/mG
         IpoOb17xEw455bJZZIp6nKd7XF0T1AthztvVI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Subject: Re: [PATCH 0/1] mouse: add qci touchpad driver
Date: Fri, 6 Aug 2010 13:44:11 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.4.5; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
References: <4C5C713D.8010902@codeaurora.org>
In-Reply-To: <4C5C713D.8010902@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008061344.13326.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 06, 2010 01:31:57 pm Neil Leeder wrote:
> This is an update of the driver that Quanta posted here a few days ago.
> Quanta wrote the original version of the driver and I am picking up
> maintenance for code aurora forum.
> 
> I've addressed the review comments. The only one that's outstanding is
> the use of the sensitivity value. I don't see an easy way that userspace
> would be able to apply the sensitivity scaling between the driver and
> say xorg, so for now I've left it in the driver, but I'd welcome any
> suggestions for improvement.
> 

Doesn't "xset mouse" do what you want?

-- 
Dmitry
