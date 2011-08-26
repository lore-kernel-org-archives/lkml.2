Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1HZMXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:23:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57178 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab1HZMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:23:53 -0400
MIME-Version: 1.0
In-Reply-To: <1314359717.12599.2.camel@phoenix>
References: <1314359717.12599.2.camel@phoenix>
Date: Fri, 26 Aug 2011 16:23:53 +0400
Message-ID: <CALT56yNaj5VyOv75O1Z5Y1biea=JSa5O-UXT4KX_eK0gBFQA_g@mail.gmail.com>
Subject: Re: [RFC][PATCH] power_supply: tosa_battery: convert to
 gpio_request_array() / gpio_free_array()
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8/26/11, Axel Lin <axel.lin@gmail.com> wrote:
> This change simplifies the implementation.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good.
Acked-By: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

> ---
> hi,
> I don't have this hardware handy. I appreciate if someone can test this
> patch.

Didn't test on hw yet, but it should work.

-- 
With best wishes
Dmitry
