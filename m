Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab0JLNds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0JLNdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:33:47 -0400
Message-ID: <4CB463A0.7050601@redhat.com>
Date: Tue, 12 Oct 2010 15:33:20 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: plain64 IV support for -stable?
References: <20101012132511.GA24455@khazad-dum.debian.net>
In-Reply-To: <20101012132511.GA24455@khazad-dum.debian.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 03:25 PM, Henrique de Moraes Holschuh wrote:
> Would it be possible to add commit 61afef614b013ee1b767cdd10325acae1db1f4d2
> "dm crypt: add plain64 iv" to -stable?
> 
> Without it, users of LTS kernels like 2.6.32 are missing important
> functionality (as in: might not be able to mount some LUKS volumes
> created on newer kernels).
 
Yes, that should not cause any problems, it should be plain cherry-pick...

(plain64 is just 64bit version of "plain" IV generator, so for <2TB devices are these equivalents)

Milan
