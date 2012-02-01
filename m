Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2BAUpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:45:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64023 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2BAUp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:45:29 -0500
Message-ID: <4F29A477.2040609@gmail.com>
Date: Wed, 01 Feb 2012 15:45:43 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.2.0 - page allocation failure: order:[2345] mode:0x20
References: <CAO9zADykAFW6omxbKfHj-6=srgcAqREqGAOyTqMt4PEEhM06KQ@mail.gmail.com>
In-Reply-To: <CAO9zADykAFW6omxbKfHj-6=srgcAqREqGAOyTqMt4PEEhM06KQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/21/12 9:38 PM), Justin Piszcz wrote:
> Hi,
>
> Question:
> Is the below normal or is this a kernel bug?

Normal, if you didn't get any user visible strangeness.

