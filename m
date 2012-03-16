Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161787Ab2CPQNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:13:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62610 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161495Ab2CPQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAEmqk_z=RtBsKaRE4ZE3wvuOjOs=CeXKvb+1iGu6bhQ_Vw-KEw@mail.gmail.com>
References: <CAEmqk_z=RtBsKaRE4ZE3wvuOjOs=CeXKvb+1iGu6bhQ_Vw-KEw@mail.gmail.com>
Date: Fri, 16 Mar 2012 17:13:38 +0100
Message-ID: <CAEmqk_zULnaBU0VYJXN2ZcwegzMVeq-h-uxw32ojS+gnKy1CZw@mail.gmail.com>
Subject: Re: Why unprivileged user cannot set SECBIT_NOROOT etc. via prctl?
From: Kant <fnord.hammer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone?

On 5 March 2012 21:25, Kant <fnord.hammer@gmail.com> wrote:
> Is there any reason why this shouldn't be allowed? It seems incredibly
> stupid that you first have to gain privileges to be able to do this.
