Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab0IEFmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 01:42:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47613 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0IEFmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 01:42:04 -0400
Message-ID: <4C832DA6.8070707@canonical.com>
Date: Sat, 04 Sep 2010 22:41:58 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: apparmor: double lock
References: <4C823419.6050906@gmail.com>
In-Reply-To: <4C823419.6050906@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2010 04:57 AM, Jiri Slaby wrote:
> Hi,
> 
> stanse found that you possibly double lock ns->lock:
> aa_remove_profiles
>   -> write_lock(&ns->lock)
>   -> __remove_namespace(ns)
>     -> destroy_namespace(ns)
>       -> write_lock(&ns->lock)
> 
> Could you fix that if that may happen at all?
> 
Yes, thanks Jiri, the patch has already been posted

http://marc.info/?l=linux-kernel&m=128295924407596&w=2

john
