Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0GHXHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:07:53 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:52395 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762Ab0GHXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:07:52 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201007082307.o68N71vX031390@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: make needlessly global symbols static
To: axel.lin@gmail.com (Axel Lin)
Date: Fri, 9 Jul 2010 08:37:01 +0930 (CST)
Cc: linux-kernel@vger.kernel.org (linux-kernel),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       mjg@redhat.com (Matthew Garrett),
       akpm@linux-foundation.org (Andrew Morton),
       stefani@seibold.net (Stefani Seibold), ak@linux.intel.com (Andi Kleen),
       platform-driver-x86@vger.kernel.org
In-Reply-To: <1278553745.7162.6.camel@mola> from "Axel Lin" at Jul 08, 2010 09:49:05 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

> The following symbols are needlessly defined global:
> 
> logolamp_led
> kblamps_led
> 
> This patch makes the symbols static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index e325aeb..a758d59 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -182,7 +182,7 @@ static enum led_brightness logolamp_get(struct led_classdev *cdev);
>  static void logolamp_set(struct led_classdev *cdev,
>  			       enum led_brightness brightness);
>  
> -struct led_classdev logolamp_led = {
> +static struct led_classdev logolamp_led = {
>   .name = "fujitsu::logolamp",
>   .brightness_get = logolamp_get,
>   .brightness_set = logolamp_set
> @@ -192,7 +192,7 @@ static enum led_brightness kblamps_get(struct led_classdev *cdev);
>  static void kblamps_set(struct led_classdev *cdev,
>  			       enum led_brightness brightness);
>  
> -struct led_classdev kblamps_led = {
> +static struct led_classdev kblamps_led = {
>   .name = "fujitsu::kblamps",
>   .brightness_get = kblamps_get,
>   .brightness_set = kblamps_set
> -- 
> 1.5.4.3
> 
> 
> 
