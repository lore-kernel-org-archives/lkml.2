Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0J1Je5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:34:57 -0400
Received: from freeflow.nu ([178.79.134.28]:52772 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0J1Jez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:34:55 -0400
Message-ID: <4CC943BE.5080607@kernel.org>
Date: Thu, 28 Oct 2010 12:34:54 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.36 io bring the system to its knees
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com> <AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com> <AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com> <AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com> <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com> <20101028090002.GA12446@elte.hu>
In-Reply-To: <20101028090002.GA12446@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/10 12:00 PM, Ingo Molnar wrote:
> * Pekka Enberg<penberg@kernel.org>  wrote:
>
>> On Thu, Oct 28, 2010 at 9:09 AM, Aidar Kultayev<the.aidar@gmail.com>  wrote:
>>> Find attached screenshot ( latencytop_n_powertop.png ) which depicts
>>> artifacts where the window manager froze at the time I was trying to
>>> see a tab in Konsole where the powertop was running.
>> You seem to have forgotten to include the attachment.
> I got it - it appears it was too large for lkml's ~500K mail size limit.
>
> Aidar, mind sending a smaller image?

Ingo, didn't you have some nice script to capture system state? Maybe 
that could shed some light to what's going on in Aidar's system?

             Pekka
