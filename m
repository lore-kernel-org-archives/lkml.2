Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1I1Nvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:51:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1I1Nvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:51:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 15/24] C6X: clocks
Date: Wed, 28 Sep 2011 15:51:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-16-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-16-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281551.37728.arnd@arndb.de>
X-Provags-ID: V02:K0:r6SOT6Vud5m8JV5YeqDORYGE3i6XPwtsC9W+tcCKPRc
 xIlopXzkxgrCFIOZEFPzjangmGtSQ/ezIcQuFfs8O5RKnmaSHo
 GD7pdUctPeHA/i0Bbsaprjsqj+p24WfQVv5tf1/BrF6tjCaJYw
 73eUxQC1kSvUgdUngViM+xOPFBGzWK32tcFHwbMv4DoJj2n7QK
 fDychCmF2qBTLMdsrgxMwArME7HYHWBSxGFCAj8Nk9zU02j4fU
 mfnM8GFy3njPTHuvpJph01kNEzD5lVQ/B2fTS5xGZYStUc+GSq
 S/jH8JXK2c544RSSJhgIcOPqKRL2yYvS/IlprMpr/gOZaawb6w
 aIKLt0saW/u4AU2Q3G4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> The C6X SoCs contain several PLL controllers each with up to 16 clock outputs
> feeding into the cores or peripheral clock domains. The hardware is very similar
> to arm/mach-davinci clocks. This is still a work in progress which needs to be
> updated once device tree clock binding changes shake out.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Yes, this will have to be reworked at some point, but it's ok for now
as long as there is no generic code to help you do this better.

Acked-by: Arnd Bergmann <arnd@arndb.de>
