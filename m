Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1HaOtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:49:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1HaOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:49:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 09/35] Hexagon: Add checksum functions
Date: Wed, 31 Aug 2011 16:49:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190800.574002538@codeaurora.org>
In-Reply-To: <20110830190800.574002538@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311649.02749.arnd@arndb.de>
X-Provags-ID: V02:K0:KbIND9hrLjvXb5XRTvcsDjJ7BQJo02jmSynYSbx1y34
 pBMxz0kuPl57Smj8JGSrQm51bE3GGupugkAnXAiKQO5mzBdXRu
 qGJQ22c0DLDHkOUXXbWvg2S5xIY6doMjtWnbnf9aplYvN71gKR
 fMW01XZBwsPZqpWvUAr/qW04M2pEvbrKzMC1EhiYMDcDNSGJNC
 OD25iWxVJ65S0JZWAzTC4Jo/UIV63E9H61V96VtUI6RTapX/tK
 TtNeLbh7mcbkltNYEqEOj0LKLJyCyq16pDFubOG9J4OoUAxsKb
 jb5kYtxgeSOdWw/IIJb0GncJNGcWJIEUll6DQh/Dmqkdc6+Jtq
 p9lNFJ0MpwSS+i8394Rk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> Removed most non-assembly functions and use the generic ones instead.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
