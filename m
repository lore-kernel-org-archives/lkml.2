Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab1CJHhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:37:01 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:35314 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1CJHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:37:00 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [PWM v7 3/3] PWM: Atmel PWMC driver
Date: Thu, 10 Mar 2011 08:36:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
References: <1299701596-24665-1-git-send-email-bgat@billgatliff.com> <1299701596-24665-4-git-send-email-bgat@billgatliff.com>
In-Reply-To: <1299701596-24665-4-git-send-email-bgat@billgatliff.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100836.54361.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 March 2011, 21:13:16 Bill Gatliff wrote:
> Driver to allow the Atmel PWMC peripheral found on various
> AT91 SoCs to be controlled using the Generic PWM framework.
> Tested on the AT91SAM9263.

As far as I can see, the previosly support for pwm_channel_handler has been 
dropped. The new API doesn't support such things.
What do you think about adding this? It might be important to change the PWM 
setup after a specific amount of time.

Alexander
