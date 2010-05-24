Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0EXXOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:14:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36175 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab0EXXOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:14:00 -0400
Message-ID: <4BFB0825.4090003@zytor.com>
Date: Mon, 24 May 2010 16:13:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [19/34] x86, k8: Fix build error when K8_NB is disabled
References: <20100524230351.044290356@clark.site>
In-Reply-To: <20100524230351.044290356@clark.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 03:59 PM, Greg KH wrote:
> 2.6.34-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> commit ade029e2aaacc8965a548b0b0f80c5bee97ffc68 upstream.
> 

Objection only that this is already in 2.6.34.

	-hpa
